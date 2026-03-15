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
 * @since 2022-04-02
 */
@Getter
@Setter
@Schema(name = "Sterilization对象", description = "")
public class Sterilization implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @Schema(description = "id")
    private Integer id;

    @Schema(description = "流浪动物id")
    private Integer animalId;

    @Schema(description = "捕捉状态")
    private String catch1;
    private String animalName;

    @Schema(description = "绝育状态")
    private String sterilization;

    @Schema(description = "放生状态")
    private String release1;

    @Schema(description = "疫苗状态")
    private String vaccine;


}
