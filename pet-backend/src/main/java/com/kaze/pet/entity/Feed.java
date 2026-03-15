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
@Schema(name = "Feed对象", description = "")
public class Feed implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "id")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @Schema(description = "环境照片1")
    private String img;

    @Schema(description = "环境照片2")
    private String img2;

    @Schema(description = "环境照片3")
    private String img3;

    @Schema(description = "地址")
    private String address;

    @Schema(description = "相关描述")
    private String information;


}
