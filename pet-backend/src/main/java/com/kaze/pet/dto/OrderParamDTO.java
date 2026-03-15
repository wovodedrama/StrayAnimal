package com.kaze.pet.dto;

import lombok.Data;

/**
 * 订单参数数据传输对象
 * @author Kaze
 */
@Data
public class OrderParamDTO {
    // 收货地址
    private String address;
    
    // 联系电话
    private String phone;
    
    // 支付方式
    private String payMethod;
    
    // 支付流水号
    private String tradeNo;
} 