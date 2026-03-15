package com.kaze.pet.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kaze.pet.entity.PetProduct;
import com.kaze.pet.mapper.PetProductMapper;
import com.kaze.pet.service.IPetProductService;
import org.springframework.stereotype.Service;

@Service
public class PetProductServiceImpl extends ServiceImpl<PetProductMapper, PetProduct> implements IPetProductService {
} 