package com.kaze.pet.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.kaze.pet.dto.RedisData;
import com.kaze.pet.entity.ArticleKp;
import com.kaze.pet.mapper.ArticleKpMapper;
import com.kaze.pet.service.IArticleKpService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 
 * @since 2022-04-04
 */
@Slf4j
@Service
public class ArticleKpServiceImpl extends ServiceImpl<ArticleKpMapper, ArticleKp> implements IArticleKpService {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private RedissonClient redissonClient;

    private static final String CACHE_ARTICLE_KEY = "stray-animal:cache:article";

    /**
     * 缓存科普文章，设置逻辑过期，防止缓存击穿
     * @param id 文章id
     * @return 文章
     */
    @Override
    public ArticleKp getDetail(Integer id) {
        String key = CACHE_ARTICLE_KEY + id;

        // 1. 从 Redis 查询数据
        String json = stringRedisTemplate.opsForValue().get(key);

        // 缓存穿透，空缓存直接返回
        if ("empty".equals(json)) {
            return null;
        }

        // 2. 如果没命中（比如 Redis 刚启动，数据还没预热），直接去查库并返回（或者返回空）
        if (StrUtil.isBlank(json)) {
            ArticleKp dbArticle = getById(id);

            // 防止缓存穿透，设置空缓存（恶意查询不存在数据）
            if (dbArticle == null) {
                stringRedisTemplate.opsForValue().set(key,"empty",5,TimeUnit.MINUTES);
                return null;
            }

            // 这里可以顺手存一下逻辑过期，防止下次还落空（预热30分钟）
            saveArticle2Redis(dbArticle, 30L);
            return dbArticle;
        }

        // 3. 命中缓存，先把 JSON 反序列化成包装对象
        RedisData redisData = JSONUtil.toBean(json, RedisData.class);
        // 注意：Hutool 的 toBean 转 Object 有时需要转成具体的 JSONObject 处理
        ArticleKp article = JSONUtil.toBean((JSONObject) redisData.getData(), ArticleKp.class);
        LocalDateTime expireTime = redisData.getExpireTime();

        // 4. 判断是否过期
        if (expireTime.isAfter(LocalDateTime.now())) {
            // 4.1 未过期，直接返回文章信息
            return article;
        }

        // 5. 已过期，需要缓存重建（只有一个线程去更新数据库）
        // 5.1 获取互斥锁
        String lockKey = "stray-animal:lock:article:" + id;
        RLock lock = redissonClient.getLock(lockKey);

        // 5.2 尝试获取锁（这里用 tryLock，拿不到不等待，直接走人）
        new Thread(() -> {
            // 只有拿到了锁的那个线程，才执行重建
            if (lock.tryLock()) {
                try {
                    log.info(">>>>>> 异步线程抢锁成功，开始重建缓存 <<<<<<");
                    ArticleKp dbArticle = getById(id);
                    this.saveArticle2Redis(dbArticle, 30L);
                } finally {
                    lock.unlock();
                }
            } else {
                log.info(">>>>>> 异步线程抢锁失败，已有其他线程在重建中 <<<<<<");
            }
        }).start();

        // 6. 拿不到锁的人，或者刚开启异步线程的人，都直接返回掉这个旧的数据
        return article;
    }

    // 辅助方法：封装逻辑过期数据并存入 Redis
    public void saveArticle2Redis(ArticleKp articleKp, Long expireMinutes) {
        RedisData redisData = new RedisData();
        redisData.setData(articleKp);
        // 设置逻辑过期时间 = 当前时间 + 传入的分钟数
        redisData.setExpireTime(LocalDateTime.now().plusMinutes(expireMinutes));

        // 写入 Redis，不设物理过期时间
        stringRedisTemplate.opsForValue().set(CACHE_ARTICLE_KEY + articleKp.getId(), JSONUtil.toJsonStr(redisData));
    }

    @Override
    public void updateArticle(ArticleKp articleKp) {
        boolean success = updateById(articleKp);
        if (success) {
            stringRedisTemplate.delete(CACHE_ARTICLE_KEY + articleKp.getId());
        }
    }
}
