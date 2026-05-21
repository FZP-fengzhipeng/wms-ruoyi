package com.ruoyi.wms.agent.domain;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class TeaAgentChatRequest {

    @NotBlank(message = "请输入问题")
    private String message;

    /** 当前会话历史（不含本条 message），用于多轮记忆 */
    private List<TeaAgentChatMessage> history = new ArrayList<>();
}
