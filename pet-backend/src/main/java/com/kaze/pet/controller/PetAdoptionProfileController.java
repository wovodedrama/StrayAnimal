package com.kaze.pet.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.kaze.pet.common.Constants;
import com.kaze.pet.common.Result;
import com.kaze.pet.entity.PetAdoptionProfile;
import com.kaze.pet.service.IPetAdoptionProfileService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 * 用户领养倾向画像表 前端控制器
 * </p>
 *
 * @author sawamura
 * @since 2026-01-12
 */
@RestController
@RequestMapping("/profile")
public class PetAdoptionProfileController {
    @Resource
    private IPetAdoptionProfileService profileService;

    @PostMapping
    public Result save(@RequestBody PetAdoptionProfile profile) {

        boolean success = profileService.saveOrUpdate(profile,
            new LambdaQueryWrapper<PetAdoptionProfile>().eq(PetAdoptionProfile::getUserId, profile.getUserId())
        );

        return success ? Result.success() : Result.error(Constants.CODE_500,"提交失败");
    }

}
