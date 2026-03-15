package com.kaze.pet.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
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
@Schema(name = "Rescue对象", description = "")
public class Rescue implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "id")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @Schema(description = "名称")
    private String name;

    @Schema(description = "地址")
    private String address;

    @Schema(description = "照片")
    private String img;

    @Schema(description = "联系人")
    private String person;

    @Schema(description = "联系方式")
    private String phone;

    @Schema(description = "相关描述")
    private String information;


}
