package com.kaze.pet.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("pet_cart")
public class PetCart {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private Integer userId;
    private Integer productId;
    private Integer quantity;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
    
    // 非数据库字段
    @TableField(exist = false)
    private String productName;
    
    @TableField(exist = false)
    private BigDecimal price;
    
    @TableField(exist = false)
    private String img;
    
    @TableField(exist = false)
    private Integer stock;
} 