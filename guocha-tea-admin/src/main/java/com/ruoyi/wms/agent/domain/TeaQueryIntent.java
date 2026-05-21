package com.ruoyi.wms.agent.domain;

import lombok.Data;

@Data
public class TeaQueryIntent {

    private TeaAgentModule module = TeaAgentModule.UNKNOWN;

    /** LIST | DETAIL | SUMMARY | OVERVIEW */
    private String action = "LIST";

    private String orderNo;

    private Integer orderStatus;

    private String merchantKeyword;

    private String warehouseKeyword;

    private int limit = 10;
}
