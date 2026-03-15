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
@TableName("pet_order")
public class PetOrder {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private String orderNo;
    private Integer userId;
    private Integer productId;
    private String productName;
    private BigDecimal productPrice;
    private Integer quantity;
    private BigDecimal totalAmount;
    private String address;
    private String phone;
    private String status;
    private String payMethod;
    private String tradeNo;


    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date payTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date updateTime;

    @TableField(exist = false)
    private String img;
} 