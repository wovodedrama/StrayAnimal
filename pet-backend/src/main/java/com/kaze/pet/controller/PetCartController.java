package com.kaze.pet.controller;

import com.kaze.pet.common.Result;
import com.kaze.pet.entity.PetCart;
import com.kaze.pet.entity.User;
import com.kaze.pet.service.IPetCartService;
import com.kaze.pet.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 购物车控制器
 */
@RestController
@RequestMapping("/pet-cart")
public class PetCartController {

    @Resource
    private IPetCartService petCartService;

    // 获取当前用户的购物车列表
    @GetMapping
    public Result getUserCarts() {
        User currentUser = getUser();
        if (currentUser == null) {
            return Result.error("401", "用户未登录");
        }
        List<PetCart> carts = petCartService.getUserCarts(currentUser.getId());
        return Result.success(carts);
    }

    // 添加商品到购物车
    @PostMapping
    public Result addToCart(@RequestBody PetCart cart) {
        User currentUser = getUser();
        if (currentUser == null) {
            return Result.error("401", "用户未登录");
        }
        cart.setUserId(currentUser.getId());
        
        boolean success = petCartService.addToCart(cart);
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "添加失败，商品可能不存在或已无库存");
        }
    }

    // 更新购物车商品数量
    @PutMapping("/{id}")
    public Result updateCartQuantity(@PathVariable Integer id, @RequestParam Integer quantity) {
        User currentUser = getUser();
        if (currentUser == null) {
            return Result.error("401", "用户未登录");
        }
        
        boolean success = petCartService.updateCartQuantity(id, quantity);
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "更新失败，数量可能超过库存");
        }
    }

    // 从购物车中删除商品
    @DeleteMapping("/{id}")
    public Result removeFromCart(@PathVariable Integer id) {
        User currentUser = getUser();
        if (currentUser == null) {
            return Result.error("401", "用户未登录");
        }
        
        boolean success = petCartService.removeFromCart(currentUser.getId(), id);
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "删除失败");
        }
    }

    // 清空购物车
    @DeleteMapping("/clear")
    public Result clearCart() {
        User currentUser = getUser();
        if (currentUser == null) {
            return Result.error("401", "用户未登录");
        }
        
        boolean success = petCartService.clearUserCart(currentUser.getId());
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "清空失败");
        }
    }

    private User getUser() {
        return TokenUtils.getCurrentUser();
    }
} 