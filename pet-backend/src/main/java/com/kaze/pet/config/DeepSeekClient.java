package com.kaze.pet.config;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kaze.pet.dto.AiMessage;
import lombok.RequiredArgsConstructor;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

/**
 * @author Kaze
 */
@Component
@RequiredArgsConstructor
public class DeepSeekClient {
    @Value("${deepseek.api-key}")
    private String apiKey;

    private static final String API_URL = "https://api.deepseek.com/v1/chat/completions";

    private final OkHttpClient client;

    @PostMapping("/chat")
    public String chat(List<AiMessage> messages) {
        try {
            String json = buildRequest(messages);

            Request httpRequest = new Request.Builder()
                .url(API_URL)
                .addHeader("Authorization", "Bearer " + apiKey)
                .addHeader("Content-Type", "application/json")
                .post(okhttp3.RequestBody.create(
                    json,
                    MediaType.parse("application/json")
                ))
                .build();

            Response response = client.newCall(httpRequest).execute();

            if (!response.isSuccessful()) {
                throw new RuntimeException("DeepSeek API error:" + response.code());
            }
            return extractContent(response.body().string());

        } catch (Exception e) {
            throw new RuntimeException("DeepSeek call failed", e);
        }
    }


    private String extractContent(String json) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(json);
            String content = root
                .path("choices")
                .get(0)
                .path("message")
                .path("content")
                .asText();

            return normalizeText(content);
        } catch (Exception e) {
            return "AI 无法回答该问题";
        }
    }

    private String normalizeText(String text) {
        // 1. 统一换行符
        text = text.replace("\r\n", "\n");

        // 2. 把 3 个及以上连续换行压缩成 2 个
        text = text.replaceAll("\n{3,}", "\n\n");

        // 3. 去掉首尾多余空白
        return text.trim();
    }

    private String buildRequest(List<AiMessage> messages) throws JsonProcessingException {
        String msgJson = new ObjectMapper().writeValueAsString(messages);

        return """
            {
              "model": "deepseek-chat",
                  "messages": %s,
                  "stream": false
            }    
            """.formatted(msgJson);
    }
}
