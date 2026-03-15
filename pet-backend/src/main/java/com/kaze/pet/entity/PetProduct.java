package com.kaze.pet.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("pet_product")
public class PetProduct {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private String name;
    private BigDecimal price;
    private String category;
    private Integer stock;
    private String description;
    private String img;
    private String status;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
} 