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
@Schema(name = "Salvation对象", description = "")
public class Salvation implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @Schema(description = "情况描述")
    private String information;

    @Schema(description = "现场照片")
    private String img;

    @Schema(description = "地点")
    private String address;

    @Schema(description = "发现时间")
    private String time;

    @Schema(description = "联系人")
    private String person;

    @Schema(description = "联系方式")
    private String phone;

    @Schema(description = "解决状态")
    private String state;


}
