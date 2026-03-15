package com.kaze.pet.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 *
 * </p>
 *
 * @author
 * @since 2022-03-19
 */
@Getter
@Setter
@Schema(name = "Comment对象", description = "")
public class Comment implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @Schema(description = "回复内容")
    private String content;

    @Schema(description = "回复人")
    private String user;

    @Schema(description = "回复时间")
    private String time;

    @Schema(description = "父id")
    private Integer pid;

    @Schema(description = "文章id")
    private Integer articleId;
    private Integer type;
    @TableField(exist = false)
    private String avatar;
    @TableField(exist = false)
    private List<Comment> children;

}
