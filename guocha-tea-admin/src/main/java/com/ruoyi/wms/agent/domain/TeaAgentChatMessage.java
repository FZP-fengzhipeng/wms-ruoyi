package com.ruoyi.wms.agent.domain;

import lombok.Data;

@Data
public class TeaAgentChatMessage {

    private String role;

    private String content;

    /** 该轮助手回复关联的单号（若有） */
    private String lastOrderNo;

    /** 该轮查询模块名称 */
    private String moduleLabel;
}
