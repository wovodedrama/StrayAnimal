package com.kaze.pet.service;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 支付服务接口
 */
public interface IPaymentService {
    
    /**
     * 创建支付宝支付
     * @param orderId 订单ID
     * @param amount 支付金额
     * @return 支付链接或表单
     */
    String createAlipayPayment(Integer orderId, BigDecimal amount);
    
    /**
     * 创建微信支付
     * @param orderId 订单ID
     * @param amount 支付金额
     * @return 支付相关参数
     */
    Map<String, String> createWechatPayment(Integer orderId, BigDecimal amount);
    
    /**
     * 处理支付宝回调
     * @param params 支付宝回调参数
     * @return 处理结果
     */
    boolean handleAlipayCallback(Map<String, String> params);
    
    /**
     * 处理微信支付回调
     * @param notifyData 微信回调数据
     * @return 处理结果
     */
    boolean handleWechatPayCallback(String notifyData);
    
    /**
     * 查询支付状态
     * @param orderNo 订单号
     * @param payMethod 支付方式
     * @return 支付状态
     */
    String queryPaymentStatus(String orderNo, String payMethod);
} 