package com.kaze.pet.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.kaze.pet.common.Constants;
import com.kaze.pet.config.RabbitMQConfig;
import com.kaze.pet.entity.Application;
import com.kaze.pet.exception.ServiceException;
import com.kaze.pet.mapper.ApplicationMapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kaze.pet.service.IApplicationService;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 
 * @since 2022-04-02
 */
@Service
public class ApplicationServiceImpl extends ServiceImpl<ApplicationMapper, Application> implements IApplicationService {

    @Autowired
    private RedissonClient redissonClient;

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Override
    public void saveApply(Application application) {
        // key : 用户id + 动物id
        String lockKey = "stray-animal:apply_lock:" + application.getUserId() + ":" + application.getAnimalId();
        // 得到Lock
        RLock lock = redissonClient.getLock(lockKey);

        try {
            boolean isLocked = lock.tryLock(0, 10, TimeUnit.SECONDS);
            if (!isLocked) {
                throw new ServiceException(Constants.CODE_600,"操作频繁，请稍后再试");
            }

            // Redis:核心幂等校验：是否已申请过同只宠物且未被拒绝
            QueryWrapper<Application> qw = new QueryWrapper<Application>()
                .eq("user_id", application.getUserId())
                .eq("animal_id", application.getAnimalId())
                .in("state","待审核","审核通过")
                .last("limit 1");

            if (this.getOne(qw) != null) {
                throw new ServiceException(Constants.CODE_600,"您已提交过领养申请，请耐心等待审核");
            }

            // MQ:发送消息到交换机
            rabbitTemplate.convertAndSend(
                RabbitMQConfig.ADOPT_EXCHANGE,
                RabbitMQConfig.ADOPT_ROUTING,
                application
            );

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();;
            throw new ServiceException(Constants.CODE_500,"系统繁忙");
        } finally {
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
}
