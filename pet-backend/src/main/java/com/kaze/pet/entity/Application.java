package com.kaze.pet.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
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
 * @since 2022-04-02
 */
@Getter
@Setter
@Schema(name = "application对象", description = "")
public class Application implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "id")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @Schema(description = "姓名")
    private String name;

    @Schema(description = "性别")
    private String sex;

    @Schema(description = "年龄")
    private Integer age;

    @Schema(description = "养宠经验")
    private String experience;

    @Schema(description = "宠物")
    private String pet;

    @Schema(description = "联系方式")
    private String phone;

    @Schema(description = "大概住址")
    private String address;

    @Schema(description = "住房性质")
    private String housing;

    @Schema(description = "领养理由")
    private String reason;

    @Schema(description = "AI风险分析")
    private String analysis;

    @Schema(description = "状态")
    private String state;

    @Schema(description = "动物id")
    private Integer animalId;
    private Integer userId;
    @TableField(exist = false)
    private Animal animal;


}
