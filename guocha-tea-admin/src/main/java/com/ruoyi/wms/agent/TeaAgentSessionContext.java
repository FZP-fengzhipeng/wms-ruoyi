package com.ruoyi.wms.agent;

import com.ruoyi.wms.agent.domain.TeaAgentChatMessage;
import com.ruoyi.wms.agent.domain.TeaAgentModule;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 从对话历史提取会话上下文（最近单号、模块等）
 */
@Data
public class TeaAgentSessionContext {

    private static final Pattern ORDER_NO = Pattern.compile("(?i)(CR|XS|DB)\\d+");

    private String lastOrderNo;

    private TeaAgentModule lastModule = TeaAgentModule.UNKNOWN;

    public static TeaAgentSessionContext fromHistory(List<TeaAgentChatMessage> history) {
        TeaAgentSessionContext ctx = new TeaAgentSessionContext();
        if (history == null || history.isEmpty()) {
            return ctx;
        }
        List<TeaAgentChatMessage> list = new ArrayList<>(history);
        for (int i = list.size() - 1; i >= 0; i--) {
            TeaAgentChatMessage msg = list.get(i);
            if (msg.getLastOrderNo() != null && !msg.getLastOrderNo().isBlank()) {
                ctx.lastOrderNo = msg.getLastOrderNo().toUpperCase(Locale.ROOT);
                ctx.lastModule = moduleFromLabel(msg.getModuleLabel());
                break;
            }
        }
        if (ctx.lastOrderNo == null) {
            for (int i = list.size() - 1; i >= 0; i--) {
                String content = list.get(i).getContent();
                if (content == null) {
                    continue;
                }
                Matcher m = ORDER_NO.matcher(content);
                if (m.find()) {
                    ctx.lastOrderNo = m.group().toUpperCase(Locale.ROOT);
                    ctx.lastModule = moduleFromOrderNo(ctx.lastOrderNo);
                    break;
                }
            }
        }
        return ctx;
    }

    private static TeaAgentModule moduleFromOrderNo(String orderNo) {
        if (orderNo.startsWith("CR")) {
            return TeaAgentModule.RECEIPT;
        }
        if (orderNo.startsWith("XS")) {
            return TeaAgentModule.SHIPMENT;
        }
        if (orderNo.startsWith("DB")) {
            return TeaAgentModule.MOVEMENT;
        }
        return TeaAgentModule.UNKNOWN;
    }

    private static TeaAgentModule moduleFromLabel(String label) {
        if (label == null) {
            return TeaAgentModule.UNKNOWN;
        }
        if (label.contains("采购") || label.contains("入仓")) {
            return TeaAgentModule.RECEIPT;
        }
        if (label.contains("销售") || label.contains("出仓")) {
            return TeaAgentModule.SHIPMENT;
        }
        if (label.contains("调拨")) {
            return TeaAgentModule.MOVEMENT;
        }
        if (label.contains("概览")) {
            return TeaAgentModule.OVERVIEW;
        }
        return TeaAgentModule.UNKNOWN;
    }
}
