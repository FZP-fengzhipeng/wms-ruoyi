package com.ruoyi.wms.agent;

import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.wms.agent.domain.TeaAgentChatMessage;
import com.ruoyi.wms.agent.domain.TeaAgentModule;
import com.ruoyi.wms.agent.domain.TeaQueryIntent;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class TeaAgentIntentParser {

    private static final Pattern ORDER_NO = Pattern.compile("(?i)(CR|XS|DB)\\d+");

    private static final String[] WRITE_PHRASES = {
        "确认入仓", "完成入仓", "确认出仓", "完成出仓", "确认调拨", "完成调拨",
        "作废", "删除单据", "新增采购", "新增出仓", "创建入仓", "执行入库", "执行出库"
    };

    public void assertReadOnly(String message) {
        for (String phrase : WRITE_PHRASES) {
            if (message.contains(phrase)) {
                throw new ServiceException("智能助手仅支持查询，不支持执行入仓、出仓、调拨等写操作");
            }
        }
    }

    public TeaQueryIntent parse(String message, List<TeaAgentChatMessage> history) {
        assertReadOnly(message);
        TeaQueryIntent intent = new TeaQueryIntent();
        String text = message.trim();
        TeaAgentSessionContext session = TeaAgentSessionContext.fromHistory(history);

        if (isRecallQuestion(text)) {
            intent.setAction("RECALL");
            if (session.getLastOrderNo() != null) {
                intent.setOrderNo(session.getLastOrderNo());
                intent.setModule(session.getLastModule() != TeaAgentModule.UNKNOWN
                    ? session.getLastModule() : resolveModuleByOrderNo(session.getLastOrderNo()));
            }
            return intent;
        }

        Matcher matcher = ORDER_NO.matcher(text);
        if (matcher.find()) {
            intent.setOrderNo(matcher.group().toUpperCase(Locale.ROOT));
            intent.setAction("DETAIL");
            intent.setModule(resolveModuleByOrderNo(intent.getOrderNo()));
            return intent;
        }

        if (isContextFollowUp(text) && session.getLastOrderNo() != null) {
            intent.setOrderNo(session.getLastOrderNo());
            intent.setModule(session.getLastModule() != TeaAgentModule.UNKNOWN
                ? session.getLastModule() : resolveModuleByOrderNo(session.getLastOrderNo()));
            if (text.contains("明细") || text.contains("详情") || text.contains("再看")) {
                intent.setAction("DETAIL");
            } else if (text.contains("多少") || text.contains("统计")) {
                intent.setAction("SUMMARY");
            } else {
                intent.setAction("DETAIL");
            }
            return intent;
        }

        if (text.contains("待处理") || text.contains("概览") || text.contains("三个模块") || text.contains("分别多少")) {
            intent.setModule(TeaAgentModule.OVERVIEW);
            intent.setAction("OVERVIEW");
            return intent;
        }

        if (text.contains("采购") || text.contains("入仓")) {
            intent.setModule(TeaAgentModule.RECEIPT);
        } else if (text.contains("销售") || text.contains("出仓")) {
            intent.setModule(TeaAgentModule.SHIPMENT);
        } else if (text.contains("调拨") || text.contains("加工")) {
            intent.setModule(TeaAgentModule.MOVEMENT);
        } else if (session.getLastModule() != TeaAgentModule.UNKNOWN) {
            intent.setModule(session.getLastModule());
        }

        if (text.contains("待入仓") || text.contains("待出仓") || text.contains("待调拨")) {
            intent.setOrderStatus(0);
        } else if (text.contains("已入仓") || text.contains("已出仓") || text.contains("已调拨")) {
            intent.setOrderStatus(1);
        } else if (text.contains("作废")) {
            intent.setOrderStatus(-1);
        }

        if (text.contains("多少") || text.contains("统计") || text.contains("合计") || text.contains("总共")) {
            intent.setAction("SUMMARY");
        }

        extractMerchantKeyword(text, intent);
        extractWarehouseKeyword(text, intent);

        if (intent.getModule() == TeaAgentModule.UNKNOWN) {
            if (text.contains("待入仓")) {
                intent.setModule(TeaAgentModule.RECEIPT);
            } else if (text.contains("待出仓")) {
                intent.setModule(TeaAgentModule.SHIPMENT);
            } else if (text.contains("待调拨")) {
                intent.setModule(TeaAgentModule.MOVEMENT);
            } else if (session.getLastOrderNo() != null) {
                intent.setOrderNo(session.getLastOrderNo());
                intent.setModule(session.getLastModule());
                intent.setAction("DETAIL");
            } else {
                intent.setModule(TeaAgentModule.OVERVIEW);
                intent.setAction("OVERVIEW");
            }
        }
        return intent;
    }

    private boolean isRecallQuestion(String text) {
        boolean timeRef = text.contains("刚才") || text.contains("刚刚") || text.contains("上一个")
            || text.contains("之前") || text.contains("上次");
        boolean askWhat = text.contains("哪个") || text.contains("什么") || text.contains("哪张")
            || text.contains("查询了") || text.contains("查过") || text.contains("单号");
        return timeRef && askWhat;
    }

    private boolean isContextFollowUp(String text) {
        return text.contains("它") || text.contains("这个") || text.contains("这张")
            || text.contains("该单") || text.contains("这笔") || text.contains("再查")
            || text.contains("继续") || text.contains("详情") || text.contains("明细");
    }

    private TeaAgentModule resolveModuleByOrderNo(String orderNo) {
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

    private void extractMerchantKeyword(String text, TeaQueryIntent intent) {
        int idx = Math.max(text.indexOf("供应商"), text.indexOf("客户"));
        if (idx >= 0) {
            String sub = text.substring(idx).replaceAll("供应商|客户", "").trim();
            if (sub.length() >= 2) {
                intent.setMerchantKeyword(sub.split("[，,。\\s]")[0]);
            }
        }
    }

    private void extractWarehouseKeyword(String text, TeaQueryIntent intent) {
        if (text.contains("茶仓") || text.contains("仓库")) {
            for (String part : text.split("[，,。\\s]")) {
                if (part.contains("仓") && part.length() >= 3) {
                    intent.setWarehouseKeyword(part.replace("茶仓", "").replace("仓库", ""));
                    break;
                }
            }
        }
    }
}
