package com.kaze.pet.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author Kaze
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AiMessage {
    private String role;
    private String content;
}