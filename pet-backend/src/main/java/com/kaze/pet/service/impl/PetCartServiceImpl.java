package com.kaze.pet.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kaze.pet.entity.PetCart;
import com.kaze.pet.entity.PetProduct;
import com.kaze.pet.mapper.PetCartMapper;
import com.kaze.pet.mapper.PetProductMapper;
import com.kaze.pet.service.IPetCartService;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class PetCartServiceImpl extends ServiceImpl<PetCartMapper, PetCart> implements IPetCartService {

    @Resource
    private PetCartMapper petCartMapper;
    
    @Resource
    private PetProductMapper petProductMapper;

    @Override
    public List<PetCart> getUserCarts(Integer userId) {
        return petCartMapper.findCartsByUserId(userId);
    }

    @Override
    public boolean addToCart(PetCart cart) {
        // 检查商品是否存在并有库存
        PetProduct product = petProductMapper.selectById(cart.getProductId());
        if (product == null || product.getStock() <= 0) {
            return false;
        }
        
        // 检查是否已在购物车中
        QueryWrapper<PetCart> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", cart.getUserId());
        queryWrapper.eq("product_id", cart.getProductId());
        PetCart existCart = getOne(queryWrapper);
        
        if (existCart != null) {
            // 已在购物车，更新数量
            existCart.setQuantity(existCart.getQuantity() + cart.getQuantity());
            return updateById(existCart);
        } else {
            // 新增到购物车
            cart.setCreateTime(new Date());
            return save(cart);
        }
    }

    @Override
    public boolean updateCartQuantity(Integer id, Integer quantity) {
        PetCart cart = getById(id);
        if (cart == null) {
            return false;
        }
        
        // 检查库存
        PetProduct product = petProductMapper.selectById(cart.getProductId());
        if (product == null || product.getStock() < quantity) {
            return false;
        }
        
        cart.setQuantity(quantity);
        return updateById(cart);
    }

    @Override
    public boolean removeFromCart(Integer userId, Integer cartId) {
        QueryWrapper<PetCart> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", cartId);
        queryWrapper.eq("user_id", userId); // 确保只能删除自己的购物车
        return remove(queryWrapper);
    }

    @Override
    public boolean clearUserCart(Integer userId) {
        QueryWrapper<PetCart> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        return remove(queryWrapper);
    }
} 