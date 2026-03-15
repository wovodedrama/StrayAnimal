package com.kaze.pet.controller;

import cn.hutool.core.date.DateUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.kaze.pet.common.Result;
import com.kaze.pet.dto.OrderParamDTO;
import com.kaze.pet.entity.PetOrder;
import com.kaze.pet.entity.User;
import com.kaze.pet.service.IPetOrderService;
import com.kaze.pet.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 宠物订单控制器
 */
@RestController
@RequestMapping("/pet-order")
public class PetOrderController {

    @Resource
    private IPetOrderService petOrderService;

    private final String now = DateUtil.now();

    // 创建单个商品订单
    @PostMapping("/create")
    public Result createOrder(@RequestBody PetOrder petOrder) {
        // 设置当前用户ID
        User currentUser = getUser();
        petOrder.setUserId(currentUser.getId());

        // 创建订单
        boolean success = petOrderService.createOrder(petOrder);
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "创建订单失败，商品不存在或库存不足");
        }
    }

    // 从购物车创建订单
    @PostMapping("/create-from-cart")
    public Result createOrderFromCart(@RequestBody OrderParamDTO params) {
        // 设置当前用户ID
        User currentUser = getUser();

        boolean success = petOrderService.createOrderFromCart(
            currentUser.getId(),
            params.getAddress(),
            params.getPhone()
        );

        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "创建订单失败，购物车为空或商品库存不足");
        }
    }

    // 支付订单
    @PostMapping("/pay/{id}")
    public Result payOrder(@PathVariable Integer id, @RequestBody OrderParamDTO params) {
        boolean success = petOrderService.payOrder(id, params.getPayMethod(), params.getTradeNo());
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "支付失败，订单不存在或状态不正确");
        }
    }

    // 发货（仅管理员）
    @PostMapping("/ship/{id}")
    public Result shipOrder(@PathVariable Integer id) {
        boolean success = petOrderService.shipOrder(id);
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "发货失败，订单不存在或状态不正确");
        }
    }

    // 确认收货
    @PostMapping("/complete/{id}")
    public Result completeOrder(@PathVariable Integer id) {
        boolean success = petOrderService.completeOrder(id);
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "确认收货失败，订单不存在或状态不正确");
        }
    }

    // 取消订单
    @PostMapping("/cancel/{id}")
    public Result cancelOrder(@PathVariable Integer id) {
        boolean success = petOrderService.cancelOrder(id);
        if (success) {
            return Result.success();
        } else {
            return Result.error("500", "取消订单失败，订单不存在或状态不允许取消");
        }
    }

    // 更新订单
    @PostMapping
    public Result save(@RequestBody PetOrder petOrder) {
        petOrderService.saveOrUpdate(petOrder);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        petOrderService.removeById(id);
        return Result.success();
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        petOrderService.removeByIds(ids);
        return Result.success();
    }

    @GetMapping
    public Result findAll() {
        return Result.success(petOrderService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(petOrderService.getById(id));
    }

    // 管理员查询订单
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String orderNo,
        @RequestParam(defaultValue = "") String status,
        @RequestParam Integer pageNum,
        @RequestParam Integer pageSize) {
        QueryWrapper<PetOrder> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("id");
        if (!"".equals(orderNo)) {
            queryWrapper.like("order_no", orderNo);
        }
        if (!"".equals(status)) {
            queryWrapper.eq("status", status);
        }
        return Result.success(petOrderService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    @GetMapping("/user/page")
    public Result userFindPage(@RequestParam(defaultValue = "") String status,
        @RequestParam Integer pageNum,
        @RequestParam Integer pageSize) {
        User currentUser = getUser();
        // 使用自定义查询方法，关联产品信息
        Page<PetOrder> page = petOrderService.findUserOrdersWithProduct(
            new Page(pageNum, pageSize),
            currentUser.getId(),
            status
        );
        return Result.success(page);
    }


    private User getUser() {
        return TokenUtils.getCurrentUser();
    }
} 