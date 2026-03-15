package com.kaze.pet.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kaze.pet.entity.PetCart;

import java.util.List;

public interface IPetCartService extends IService<PetCart> {
    
    // 获取用户购物车列表
    List<PetCart> getUserCarts(Integer userId);
    
    // 添加商品到购物车
    boolean addToCart(PetCart cart);
    
    // 更新购物车商品数量
    boolean updateCartQuantity(Integer id, Integer quantity);
    
    // 从购物车中删除商品
    boolean removeFromCart(Integer userId, Integer cartId);
    
    // 清空用户购物车
    boolean clearUserCart(Integer userId);
} 