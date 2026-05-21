# 茶仓智能查询助手 — 技术方案

## 约束

- **仅查询**：不调用入仓、出仓、调拨、作废、删除等写接口。
- **大模型**：DeepSeek（OpenAI 兼容 API，`https://api.deepseek.com`）。
- **输出**：Spring MVC + **SSE** 流式返回。

## 技术栈

| 层级 | 选型 |
|------|------|
| API | Spring MVC `SseEmitter` |
| LLM | DeepSeek Chat Completions（流式），协议与 Spring AI OpenAI 模块一致 |
| 编排 | `TeaAgentService` + 白名单 `TeaWmsQueryExecutor` |
| 前端 | Vue3 + `fetch` 读 SSE |

## 接口

- `POST /wms/teaAgent/chat` — 同步一问一答（可选）
- `POST /wms/teaAgent/chat/stream` — SSE：`data`（查询结果）→ `token`（DeepSeek 流）→ `done`

## 配置（application-dev.yml）

```yaml
tea:
  agent:
    deepseek:
      enabled: true
      api-key: ${DEEPSEEK_API_KEY:}
      base-url: https://api.deepseek.com
      model: deepseek-chat
```

## 菜单

- 名称：茶仓智能查询助手
- 路径：`teaAgent`，组件：`wms/teaAgent/index`
- 排序：`order_num=9`（茶企档案之前）
