package com.kaze.pet.service;

import com.kaze.pet.entity.Animal;

import java.util.List;

public interface IRecommendService {

    List<Animal> getRecommandList(Integer userId);
}