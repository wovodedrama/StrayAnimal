package com.kaze.pet.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.kaze.pet.entity.PetOrder;

public interface IPetOrderService extends IService<PetOrder> {
    // 创建单个商品订单
    boolean createOrder(PetOrder petOrder);
    
    // 从购物车创建订单
    boolean createOrderFromCart(Integer userId, String address, String phone);
    
    // 支付订单
    boolean payOrder(Integer orderId, String payMethod, String tradeNo);
    
    // 发货
    boolean shipOrder(Integer orderId);
    
    // 确认收货
    boolean completeOrder(Integer orderId);
    
    // 取消订单
    boolean cancelOrder(Integer orderId);

    Page<PetOrder> findUserOrdersWithProduct(Page page, Integer userId, String status);
} 