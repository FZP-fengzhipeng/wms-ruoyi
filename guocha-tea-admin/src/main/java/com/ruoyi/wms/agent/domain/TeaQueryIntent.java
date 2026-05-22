package com.ruoyi.wms.agent.domain;

import lombok.Data;

@Data
public class TeaQueryIntent {

    private TeaAgentModule module = TeaAgentModule.UNKNOWN;

    /** LIST | DETAIL | SUMMARY | OVERVIEW | RECALL | UNMATCHED */
    private String action = "LIST";

    /** 茶品名称关键词（查库存/茶仓） */
    private String itemKeyword;

    private String orderNo;

    private Integer orderStatus;

    private String merchantKeyword;

    private String warehouseKeyword;

    private int limit = 10;
}
