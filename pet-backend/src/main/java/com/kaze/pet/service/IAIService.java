package com.kaze.pet.service;

import reactor.core.publisher.Flux;

/**
 * @author Kaze
 */
public interface IAIService {

    public Flux<String> chatStream(String userKey, String question);

//    String chat(String userKey, String message);
}
