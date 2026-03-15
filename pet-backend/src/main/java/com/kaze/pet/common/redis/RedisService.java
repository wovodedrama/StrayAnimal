package com.kaze.pet.common.redis;

import jakarta.annotation.Resource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

/**
 * @author Kaze
 */
@Service
public class RedisService {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    public void set(String key,String value,long seconds) {
        stringRedisTemplate.opsForValue().set(key,value,seconds,TimeUnit.SECONDS);
    }

    public String get(String key) {
        return stringRedisTemplate.opsForValue().get(key);
    }

    public boolean isExist(String key) {
        return Boolean.TRUE.equals(stringRedisTemplate.hasKey(key));
    }

    public void delete(String key) {
        stringRedisTemplate.delete(key);
    }

    /**
     * 限流
     * @param key 唯一标识(ip / userId)
     * @param maxCount 时间窗口内最大次数
     * @param seconds 时间窗口（秒）
     * @return 是否allow
     */
    public boolean allowRequest(String key, int maxCount, int seconds) {
        Long count = stringRedisTemplate.opsForValue().increment(key);

        if (count == 1) {
            // 第一次访问时，设置过期时间
            stringRedisTemplate.expire(key,seconds, TimeUnit.SECONDS);
        }

        return count <= maxCount;
    }
}
