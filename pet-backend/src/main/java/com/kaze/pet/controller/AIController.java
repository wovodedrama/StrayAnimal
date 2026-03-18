package com.kaze.pet.controller;

import com.kaze.pet.common.Constants;
import com.kaze.pet.common.Result;
import com.kaze.pet.common.redis.RedisService;
import com.kaze.pet.dto.AiChatRequest;
import com.kaze.pet.service.IAIService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.annotation.Resource;
import reactor.core.publisher.Flux;

/**
 * @author Kaze
 */
@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
public class AIController {

    @Value("${deepseek.api-key}")
    private String apiKey;
    @Resource
    private IAIService aiService;
    @Resource
    private RedisService redisService;
    private static final String API_URL = "https://api.deepseek.com/v1/chat/completions";

    private final OkHttpClient client;

    /**
     * 发送消息给AI
     * MediaType.TEXT_EVENT_STREAM_VALUE: SSE协议头（当有数据时即时显示）
     * @return Flux 流式响应（即消息并非直接全部出来而是一点点生成出来）
     */
    @PostMapping(value = "/chat",produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> chat(@RequestBody AiChatRequest request, HttpServletRequest httpRequest) {
        String ip = httpRequest.getRemoteAddr();
        // 限流
        String rateKey = "stray-animal:ai:rate:" + ip;
        // 拿到token
        String userKey = httpRequest.getHeader("token");

        if (!redisService.allowRequest(rateKey,5,60)) {
            return Flux.just(Constants.CODE_600,"请求过于频繁，请稍后再试！");
        }
        return aiService.chatStream(userKey,request.getMessage());
    }

    private String getClientIp(HttpServletRequest request) {
        return request.getRemoteAddr();
    }

}
