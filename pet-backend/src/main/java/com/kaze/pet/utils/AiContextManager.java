package com.kaze.pet.utils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kaze.pet.common.redis.RedisService;
import com.kaze.pet.dto.AiMessage;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Kaze
 */
@Component
public class AiContextManager {

    // 最多保存六条
    private static final int MAX_MESSAGES = 6;
    // 保存30min
    private static final long TTL = 1800;

    @Resource
    private RedisService redisService;

    private final ObjectMapper mapper = new ObjectMapper();

    public List<AiMessage> getContext(String key) {
        if (!redisService.isExist(key)) {
            // 没有上下文
            return new ArrayList<>();
        }
        try {
            String json = redisService.get(key);
            // json->List<AiMessage>
            return mapper.readValue(json, new TypeReference<List<AiMessage>>() {
            });
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    public void append(String key, AiMessage message) {
        List<AiMessage> list = getContext(key);
        list.add(message);

        if (list.size() > MAX_MESSAGES) {
            // 超出长度就删最早的一条
            list = list.subList(list.size() - MAX_MESSAGES, list.size());
        }

        try {
            redisService.set(key, mapper.writeValueAsString(list), TTL);
        } catch (Exception ignored) {}
    }
}
