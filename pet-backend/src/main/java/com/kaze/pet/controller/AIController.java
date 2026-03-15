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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.annotation.Resource;

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

    @PostMapping("/chat")
    public Result chat(@RequestBody AiChatRequest request, HttpServletRequest httpRequest) {
        String ip = httpRequest.getRemoteAddr();
        String key = "stray-animal:ai:rate:" + ip;

        // 拿到token
        String userKey = httpRequest.getHeader("token");

        if (!redisService.allowRequest(key,5,60)) {
            return Result.error(Constants.CODE_600,"请求过于频繁，请稍后再试！");
        }
        return Result.success(aiService.chat(userKey,request.getMessage()));
    }

    private String getClientIp(HttpServletRequest request) {
        return request.getRemoteAddr();
    }

}
