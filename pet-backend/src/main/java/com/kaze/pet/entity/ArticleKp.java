package com.kaze.pet.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 
 * </p>
 *
 * @author 
 * @since 2022-04-04
 */
@Getter
@Setter
@TableName("article_kp")
@Schema(name = "ArticleKp对象", description = "")
public class ArticleKp implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @Schema(description = "标题")
    private String name;

    @Schema(description = "内容")
    private String content;

    @Schema(description = "时间")
    private String time;

    @Schema(description = "封面")
    private String img;

    @Schema(description = "阅读数")
    private Integer read1;


}
