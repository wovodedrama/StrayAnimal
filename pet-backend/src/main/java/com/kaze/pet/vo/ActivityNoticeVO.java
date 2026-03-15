package com.kaze.pet.vo;

import lombok.Data;

/**
 * @author Kaze
 */
@Data
public class ActivityNoticeVO {
    private static final long serialVersionUID = 1L;

    private Integer id;
    // 活动名称
    private String name;
    // 活动内容
    private String content;
    // 活动举行时间
    private String time;
}
