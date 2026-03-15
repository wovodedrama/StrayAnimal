package com.kaze.pet.controller;

import com.kaze.pet.common.Result;
import com.kaze.pet.entity.Animal;
import com.kaze.pet.entity.User;
import com.kaze.pet.service.IRecommendService;
import com.kaze.pet.service.IUserService;
import com.kaze.pet.utils.TokenUtils;
import com.kaze.pet.utils.UserContext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.annotation.Resource;

import java.util.List;

/**
 * @author Kaze
 */
@RestController
@RequestMapping("/recommend")
public class RecommendController {

    @Resource
    private IRecommendService recommendService;

    @Resource
    private IUserService userService;

    @GetMapping("/animals")
    public Result recommendAnimals() {
        User currentUser = TokenUtils.getCurrentUser();
        if (currentUser != null) {
            // 从数据库获取最新的用户信息
            User user = UserContext.getUser();
//            User user = userService.getById(currentUser.getId());
            List<Animal> recommendations =  recommendService.getRecommandList(user.getId());

            if (recommendations == null) {
                return Result.error("600", "请先填写领养倾向评估表单");
            }

            return Result.success(recommendations);
        } else {
            return Result.error("401", "用户未登录");
        }
    }
}