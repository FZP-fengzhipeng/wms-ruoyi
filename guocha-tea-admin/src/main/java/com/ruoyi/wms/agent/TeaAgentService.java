package com.ruoyi.wms.agent;

import cn.hutool.json.JSONUtil;
import com.ruoyi.wms.agent.config.TeaAgentProperties;
import com.ruoyi.wms.agent.domain.TeaAgentChatMessage;
import com.ruoyi.wms.agent.domain.TeaAgentChatRequest;
import com.ruoyi.wms.agent.domain.TeaQueryIntent;
import com.ruoyi.wms.agent.domain.TeaQueryResult;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
@RequiredArgsConstructor
public class TeaAgentService {

    private static final int MAX_HISTORY_TURNS = 12;

    private static final String SYSTEM_PROMPT = """
        你是国茶经营管理系统的茶仓智能查询助手。你只能根据提供的查询结果进行说明，禁止建议或执行入仓、出仓、调拨、作废、删除等写操作。
        回答使用简洁中文，先给结论，再列要点。不要编造查询结果中没有的数据。
        若用户追问「刚才查了哪个单号」等，以查询结果中的会话记忆为准，勿说成「三模块概览」。
        """;

    private final TeaAgentIntentParser intentParser;
    private final TeaWmsQueryExecutor queryExecutor;
    private final DeepSeekChatClient deepSeekChatClient;
    private final TeaAgentProperties properties;

    public SseEmitter streamChat(TeaAgentChatRequest request) {
        SseEmitter emitter = new SseEmitter(120_000L);
        CompletableFuture.runAsync(() -> handleStream(request, emitter));
        return emitter;
    }

    private void handleStream(TeaAgentChatRequest request, SseEmitter emitter) {
        try {
            List<TeaAgentChatMessage> history = request.getHistory() != null ? request.getHistory() : List.of();
            TeaQueryIntent intent = intentParser.parse(request.getMessage(), history);
            TeaQueryResult queryResult = queryExecutor.execute(intent);
            if (queryResult.getLastOrderNo() == null && intent.getOrderNo() != null) {
                queryResult.setLastOrderNo(intent.getOrderNo());
            }

            emitter.send(SseEmitter.event().name("data").data(JSONUtil.toJsonStr(queryResult)));

            String userPrompt = "用户问题：" + request.getMessage() + "\n\n查询模块：" + queryResult.getModuleLabel()
                + "\n简要结果：" + queryResult.getBriefSummary()
                + "\n明细数据：\n" + queryResult.getDataContext();

            if (!properties.isConfigured()) {
                emitter.send(SseEmitter.event().name("token").data(queryResult.getBriefSummary()));
                emitter.send(SseEmitter.event().name("done").data("[DONE]"));
                emitter.complete();
                return;
            }

            List<TeaAgentChatMessage> llmHistory = trimHistory(history);
            deepSeekChatClient.streamChat(SYSTEM_PROMPT, llmHistory, userPrompt, token -> {
                try {
                    emitter.send(SseEmitter.event().name("token").data(token));
                } catch (IOException e) {
                    emitter.completeWithError(e);
                }
            });

            emitter.send(SseEmitter.event().name("done").data("[DONE]"));
            emitter.complete();
        } catch (Exception ex) {
            try {
                emitter.send(SseEmitter.event().name("error").data(ex.getMessage()));
            } catch (IOException ignored) {
            }
            emitter.completeWithError(ex);
        }
    }

    private List<TeaAgentChatMessage> trimHistory(List<TeaAgentChatMessage> history) {
        if (history == null || history.isEmpty()) {
            return List.of();
        }
        int from = Math.max(0, history.size() - MAX_HISTORY_TURNS);
        return new ArrayList<>(history.subList(from, history.size()));
    }
}
