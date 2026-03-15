package com.kaze.pet.config;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author Kaze
 */
@Configuration
public class RabbitMQConfig {

    public static final String ADOPT_QUEUE = "adopt.apply.queue";
    public static final String ADOPT_EXCHANGE = "adopt.apply.exchange";
    public static final String ADOPT_ROUTING = "adopt.apply.routing";

    // 领养队列
    @Bean
    public Queue adoptQueue() {
        // 持久化队列
        return new Queue(ADOPT_QUEUE, true);
    }

    // 定义交换机
    @Bean
    public DirectExchange adoptExchange() {
        return new DirectExchange(ADOPT_EXCHANGE);
    }

    // 绑定队列和交换机
    @Bean
    public Binding bindingAdopt() {
        return BindingBuilder.bind(adoptQueue()).to(adoptExchange()).with(ADOPT_ROUTING);
    }
    // 将消息转换为JSON
    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
