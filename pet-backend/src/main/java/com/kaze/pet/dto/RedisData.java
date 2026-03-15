package com.kaze.pet.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * @author Kaze
 */
@Data
public class RedisData {
    // 逻辑过期时间
    private LocalDateTime expireTime;
    private Object data;
}
