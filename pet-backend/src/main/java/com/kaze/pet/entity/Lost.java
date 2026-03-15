package com.kaze.pet.entity;

import java.io.Serializable;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
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
@Schema(name = "Lost对象", description = "")
public class Lost implements Serializable {

    private static final long serialVersionUID = 1L;
@TableId(type = IdType.AUTO)
    @Schema(description = "id")
    private Integer id;

    @Schema(description = "走失宠物名字")
    private String nickname;

    @Schema(description = "种类")
    private String type;

    @Schema(description = "性别")
    private String sex;

    @Schema(description = "联系人")
    private String person;

    @Schema(description = "联系方式")
    private String phone;

    @Schema(description = "已丢失/带领回")
    private String status1;

    @Schema(description = "找回状态")
    private String status2;


}
