package com.kaze.pet.service.impl;

import com.kaze.pet.common.redis.RedisService;
import com.kaze.pet.config.DeepSeekClient;
import com.kaze.pet.dto.AiMessage;
import com.kaze.pet.service.IAIService;
import com.kaze.pet.utils.AiContextManager;
import jakarta.annotation.Resource;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Kaze
 */
@Service
@RequiredArgsConstructor
public class AIServiceImpl implements IAIService {

    private final DeepSeekClient client;
    @Resource
    private RedisService redisService;
    @Resource
    private AiContextManager aiContextManager;

    @Override
    public String chat(String userKey, String question) {
        // 构造key
        String cacheKey = "stray-animal:ai:chat:" + DigestUtils.md5DigestAsHex(question.getBytes());

        // 命中缓存,直接返回
        if (redisService.isExist(cacheKey)) {
            return redisService.get(cacheKey);
        }

        String contextKey = "stray-animal:ai:context:" + userKey;
        // 取上下文
        List<AiMessage> history = aiContextManager.getContext(contextKey);
        List<AiMessage> messages = new ArrayList<>();
        // 1. 加 system prompt
        messages.add(new AiMessage(
            "system",
            "你是宠物领养顾问。只回答领养问题。要求：纯文本段落形式，严禁使用Markdown格式（如#、*、-、数字列表），限300字内。"
        ));

        // 2. 上下文接在system后面
        if (history != null && !history.isEmpty()) {
            messages.addAll(history);
        }
        // 3. 用户当前问题
        messages.add(new AiMessage("user",question));
        // 4. 调用AI
        String answer = client.chat(messages);

        // 5. 回写上下文
        aiContextManager.append(contextKey, new AiMessage("user",question));

        // 写缓存（缓存十分钟）
        redisService.set(cacheKey,answer,600);
        return answer;
    }
}
