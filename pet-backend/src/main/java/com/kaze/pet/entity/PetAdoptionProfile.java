package com.kaze.pet.entity;

/**
 * @author Kaze
 */
import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户领养倾向画像实体类
 */
@Data
@TableName("pet_adoption_profile")
public class PetAdoptionProfile {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 关联用户ID
     */
    private Long userId;

    /**
     * 每天可陪伴时长：0-少于2小时，1-2到5小时，2-5小时以上
     */
    private Integer dailyTime;

    /**
     * 生活节奏/运动量：0-低(居家静止)，1-中(偶尔散步)，2-高(经常户外)
     */
    private Integer activityLevel;

    /**
     * 养宠经验：0-新手小白，1-有一定经验，2-资深大佬
     */
    private Integer experienceLevel;

    /**
     * 是否接受掉毛：0-不接受，1-接受
     */
    private Integer acceptShedding;

    /**
     * 是否接受吵闹：0-喜欢安静，1-不介意
     */
    private Integer acceptNoise;

    /**
     * 居住空间：0-公寓/开间，1-普通套房，2-自带院子
     */
    private Integer spaceSize;

    /**
     * 倾向的宠物性格关键词(逗号分隔，如：温顺,独立)
     */
    private String prefPersonality;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
