package com.ruoyi.wms.agent.domain;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class TeaQueryResult {

    private String moduleLabel;

    private String dataContext;

    private String briefSummary;

    /** 是否将 briefSummary 预填到对话正文（无法回答的问题应为 false） */
    private boolean prefillBriefSummary = true;

    /** 本轮查询关联的单号，供前端写入会话历史 */
    private String lastOrderNo;

    private List<String> navigateHints = new ArrayList<>();
}
