package com.ruoyi.wms.agent;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.ruoyi.wms.agent.config.TeaAgentProperties;
import com.ruoyi.wms.agent.domain.TeaAgentChatMessage;
import lombok.RequiredArgsConstructor;
import okhttp3.*;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.function.Consumer;

@Component
@RequiredArgsConstructor
public class DeepSeekChatClient {

    private static final int MAX_CONTENT_LEN = 2000;

    private final TeaAgentProperties properties;

    private final OkHttpClient client = new OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(120, TimeUnit.SECONDS)
        .build();

    public void streamChat(String systemPrompt, List<TeaAgentChatMessage> history,
                           String finalUserPrompt, Consumer<String> onToken) throws IOException {
        if (!properties.isConfigured()) {
            onToken.accept("（未配置 DeepSeek API Key，仅展示查询结果。请在 application-dev.yml 配置 tea.agent.deepseek.api-key）");
            return;
        }
        JSONObject body = new JSONObject();
        body.set("model", properties.getModel());
        body.set("stream", true);
        body.set("temperature", 0.3);
        JSONArray messages = new JSONArray();
        messages.add(new JSONObject().set("role", "system").set("content", systemPrompt));
        if (history != null) {
            for (TeaAgentChatMessage msg : history) {
                if (msg.getRole() == null || msg.getContent() == null) {
                    continue;
                }
                String role = msg.getRole();
                if (!"user".equals(role) && !"assistant".equals(role)) {
                    continue;
                }
                messages.add(new JSONObject().set("role", role).set("content", truncate(msg.getContent())));
            }
        }
        messages.add(new JSONObject().set("role", "user").set("content", finalUserPrompt));
        body.set("messages", messages);

        String url = properties.getBaseUrl().replaceAll("/$", "") + "/v1/chat/completions";
        Request request = new Request.Builder()
            .url(url)
            .addHeader("Authorization", "Bearer " + properties.getApiKey())
            .addHeader("Content-Type", "application/json")
            .post(RequestBody.create(body.toString(), MediaType.parse("application/json")))
            .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful() || response.body() == null) {
                onToken.accept("DeepSeek 调用失败：" + (response.body() != null ? response.body().string() : response.code()));
                return;
            }
            BufferedReader reader = new BufferedReader(new InputStreamReader(response.body().byteStream(), StandardCharsets.UTF_8));
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.startsWith("data:")) {
                    continue;
                }
                String data = line.substring(5).trim();
                if ("[DONE]".equals(data)) {
                    break;
                }
                JSONObject chunk = JSONUtil.parseObj(data);
                JSONArray choices = chunk.getJSONArray("choices");
                if (choices == null || choices.isEmpty()) {
                    continue;
                }
                JSONObject delta = choices.getJSONObject(0).getJSONObject("delta");
                if (delta != null && delta.containsKey("content")) {
                    String content = delta.getStr("content");
                    if (content != null && !content.isEmpty()) {
                        onToken.accept(content);
                    }
                }
            }
        }
    }

    private String truncate(String text) {
        if (text == null) {
            return "";
        }
        String plain = text.replaceAll("<[^>]+>", "");
        if (plain.length() <= MAX_CONTENT_LEN) {
            return plain;
        }
        return plain.substring(0, MAX_CONTENT_LEN) + "…";
    }
}
