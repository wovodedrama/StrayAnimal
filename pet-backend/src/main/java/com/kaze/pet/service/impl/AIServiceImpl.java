package com.kaze.pet.service.impl;

import com.kaze.pet.common.redis.RedisService;
import com.kaze.pet.dto.AiMessage;
import com.kaze.pet.service.IAIService;
import com.kaze.pet.utils.AiContextManager;
import jakarta.annotation.Resource;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import reactor.core.publisher.Flux;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Kaze
 */
@Service
@RequiredArgsConstructor
public class AIServiceImpl implements IAIService {
//    private final DeepSeekClient client; // 旧的DeepSeek调用方式
    // Spring AI
    @Autowired
    private ChatModel chatModel;
    @Resource
    private RedisService redisService;
    @Resource
    private AiContextManager aiContextManager;

    public Flux<String> chatStream(String userKey, String question) {
        // 缓存key
        String cacheKey = "stray-animal:ai:chat:" + DigestUtils.md5DigestAsHex(question.getBytes());

        // 命中缓存,直接返回
        if (redisService.isExist(cacheKey)) {
            String cached = redisService.get(cacheKey);
            // TODO
            return Flux.fromArray(cached.split(""))
                .delayElements(Duration.ofMillis(30));
        }

        String contextKey = "stray-animal:ai:context:" + userKey;
        // 构造消息列表
        List<Message> messages = new ArrayList<>();
        // 1. 加 system prompt
        messages.add(new SystemMessage(
            "你是宠物领养顾问。只回答领养问题。要求：纯文本段落形式，严禁使用Markdown格式（如#、*、-、数字列表），限300字内。"
        ));
        // 2. 放上下文
        List<AiMessage> history = aiContextManager.getContext(contextKey);
        if (history != null) {
            history.forEach(h -> {
                if ("user".equals(h.getRole())) messages.add(new UserMessage(h.getContent()));
                else messages.add(new AssistantMessage((h.getContent())));
            });
        }
        // 添加本次用户提问
        messages.add(new UserMessage(question));

        StringBuilder fullAnswer = new StringBuilder();

        return chatModel.stream(new Prompt(messages))
            .map(res -> {
                String text = res.getResult().getOutput().getText(); // TODO
                return text != null ? text : "";
            })
            // 实时累加回复内容到StringBuilder中，收集消息碎片
            .doOnNext(fullAnswer::append)
            .doOnComplete(() -> {
                // 异步进行持久化操作
                String finalContent = fullAnswer.toString().trim();
                if (!finalContent.isEmpty()) {
                    // 历史上下文（用户提问和AI回答）
                    aiContextManager.append(contextKey,new AiMessage("user",question));
                    aiContextManager.append(contextKey,new AiMessage("assistant",finalContent));
                    // 回答的缓存
                    redisService.set(cacheKey,finalContent,600);
                }
            });
    }
// 旧的chat方法（无流式响应）
//    @Override
//    public String chat(String userKey, String question) {
//        // 构造key
//        String cacheKey = "stray-animal:ai:chat:" + DigestUtils.md5DigestAsHex(question.getBytes());
//
//        // 命中缓存,直接返回
//        if (redisService.isExist(cacheKey)) {
//            return redisService.get(cacheKey);
//        }
//
//        String contextKey = "stray-animal:ai:context:" + userKey;
//        // 取上下文
//        List<AiMessage> history = aiContextManager.getContext(contextKey);
//        List<AiMessage> messages = new ArrayList<>();
//        // 1. 加 system prompt
//        messages.add(new AiMessage(
//            "system",
//            "你是宠物领养顾问。只回答领养问题。要求：纯文本段落形式，严禁使用Markdown格式（如#、*、-、数字列表），限300字内。"
//        ));
//
//        // 2. 上下文接在system后面
//        if (history != null && !history.isEmpty()) {
//            messages.addAll(history);
//        }
//        // 3. 用户当前问题
//        messages.add(new AiMessage("user",question));
//        // 4. 调用AI
//        String answer = client.chat(messages);
//
//        // 5. 回写上下文
//        aiContextManager.append(contextKey, new AiMessage("user",question));
//
//        // 写缓存（缓存十分钟）
//        redisService.set(cacheKey,answer,600);
//        return answer;
//    }


}
