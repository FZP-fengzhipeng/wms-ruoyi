package com.ruoyi.wms.agent.domain;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class TeaQueryResult {

    private String moduleLabel;

    private String dataContext;

    private String briefSummary;

    /** 本轮查询关联的单号，供前端写入会话历史 */
    private String lastOrderNo;

    private List<String> navigateHints = new ArrayList<>();
}
