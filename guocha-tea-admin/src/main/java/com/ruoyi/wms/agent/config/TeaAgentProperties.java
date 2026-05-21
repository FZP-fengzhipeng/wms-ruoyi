package com.ruoyi.wms.agent.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "tea.agent.deepseek")
public class TeaAgentProperties {

    private boolean enabled = true;

    private String apiKey = "";

    private String baseUrl = "https://api.deepseek.com";

    private String model = "deepseek-chat";

    public boolean isConfigured() {
        return enabled && apiKey != null && !apiKey.isBlank();
    }
}
