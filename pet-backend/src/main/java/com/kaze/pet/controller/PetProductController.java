package com.kaze.pet.controller;

import cn.hutool.core.date.DateUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.kaze.pet.common.Result;
import com.kaze.pet.config.interceptor.AuthAccess;
import com.kaze.pet.entity.PetProduct;
import com.kaze.pet.service.IPetProductService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * 宠物商品控制器
 */
@RestController
@RequestMapping("/pet-product")
public class PetProductController {

    @Resource
    private IPetProductService petProductService;

    private final String now = DateUtil.now();

    // 新增或者更新
    @PostMapping
    public Result save(@RequestBody PetProduct petProduct) {
        if (petProduct.getId() == null) {
            petProduct.setCreateTime(new Date());
        }
        petProductService.saveOrUpdate(petProduct);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        petProductService.removeById(id);
        return Result.success();
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        petProductService.removeByIds(ids);
        return Result.success();
    }

    @GetMapping
    public Result findAll() {
        return Result.success(petProductService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(petProductService.getById(id));
    }

    @AuthAccess
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam(defaultValue = "") String category,
                           @RequestParam(defaultValue = "") String status,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<PetProduct> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("id");
        if (!"".equals(name)) {
            queryWrapper.like("name", name);
        }
        if (!"".equals(category)) {
            queryWrapper.eq("category", category);
        }
        if (!"".equals(status)) {
            queryWrapper.eq("status", status);
        }
        return Result.success(petProductService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }
    
    @AuthAccess
    @GetMapping("/front/page")
    public Result frontFindPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam(defaultValue = "") String category,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<PetProduct> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("id");
        queryWrapper.eq("status", "上架"); // 只显示上架商品
        if (!"".equals(name)) {
            queryWrapper.like("name", name);
        }
        if (!"".equals(category)) {
            queryWrapper.eq("category", category);
        }
        return Result.success(petProductService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }
} 