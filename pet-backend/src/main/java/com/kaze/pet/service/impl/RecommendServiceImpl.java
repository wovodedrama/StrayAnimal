package com.kaze.pet.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.kaze.pet.entity.Animal;
import com.kaze.pet.entity.PetAdoptionProfile;
import com.kaze.pet.mapper.AnimalMapper;
import com.kaze.pet.mapper.PetAdoptionProfileMapper;
import com.kaze.pet.service.IRecommendService;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class RecommendServiceImpl implements IRecommendService {

    @Resource
    private AnimalMapper animalMapper;

    @Resource
    private PetAdoptionProfileMapper profileMapper;


    @Override
    public List<Animal> getRecommandList(Integer userId) {
        // 1. 得到用户画像表单
        PetAdoptionProfile profile = profileMapper.selectOne(
            new LambdaQueryWrapper<PetAdoptionProfile>().eq(PetAdoptionProfile::getUserId, userId));

        // 未填写表单
        if (profile == null) return null;

        // 2. 获取所有待领养宠物
        List<Animal> animals = animalMapper.selectList(
            new LambdaQueryWrapper<Animal>()
                .eq(Animal::getAdopt, "可领养")
                .eq(Animal::getIsAdopt, "否")
        );

        // 3. 匹配算法 (计算匹配分数，降序排序，筛选五只，形成集合)
        return animals.stream()
            .map(animal -> new ScoredAnimal(animal,calculateMatchScore(animal,profile)))
            .sorted(Comparator.comparingDouble(ScoredAnimal::getScore).reversed())
            .limit(5)
            .map(ScoredAnimal::getAnimal)
            .collect(Collectors.toList());
    }


    private double calculateMatchScore(Animal animal, PetAdoptionProfile profile) {
        double score = 0.0;

        // 1. 性格标签匹配
        if (profile.getPrefPersonality() != null && animal.getInformation() != null) {
            String[] userPrefs = profile.getPrefPersonality().split(",");
            for (String pref : userPrefs) {
                if (animal.getInformation().contains(pref)) {
                    // 匹配到一个关键词+30
                    score += 30.0;
                }
            }
        }

        // 2. 生活节奏
        if (animal.getInformation() != null && animal.getInformation().contains("需要陪伴")) {
            // 宠物需要陪伴 --> 用户每天可以陪2小时以上
            if (profile.getDailyTime() >= 2) score += 20.0;
            else if (profile.getDailyTime() == 1) score += 10.0;
        }

        // 3. 硬性条件（掉毛与噪音）
        if (profile.getAcceptShedding() == 0 && animal.getInformation().contains("掉毛")) {
            // 用户不能接受直接扣50分
            score -= 50.0;
        }
        if (profile.getAcceptNoise() == 0 && animal.getInformation().contains("吵闹")) {
            score -= 50.0;
        }

        // 4. 经验值偏好 性格凶猛 患病的宠物需要有经验的用户
        if (profile.getExperienceLevel() > 0 && !"健康".equals(animal.getStatus())) {
            score += 15.0;
        }

        return score;
    }

    // 用于记录动物和匹配分数的内部类
    @Data
    @AllArgsConstructor
    private static class ScoredAnimal {
        private final Animal animal;
        private final double score;

    }


}