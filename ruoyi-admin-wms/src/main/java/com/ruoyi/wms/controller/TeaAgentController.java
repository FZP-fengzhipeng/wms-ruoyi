package com.ruoyi.wms.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.wms.agent.TeaAgentService;
import com.ruoyi.wms.agent.domain.TeaAgentChatRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

/**
 * 茶仓智能查询助手（仅查询）
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/teaAgent")
public class TeaAgentController extends BaseController {

    private final TeaAgentService teaAgentService;

    @SaCheckPermission("wms:teaAgent:chat")
    @PostMapping(value = "/chat/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter stream(@Valid @RequestBody TeaAgentChatRequest request) {
        return teaAgentService.streamChat(request);
    }
}
