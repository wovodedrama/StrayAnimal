package com.kaze.pet.service.impl;

import com.kaze.pet.entity.Animal;
import com.kaze.pet.mapper.AnimalMapper;
import com.kaze.pet.service.IAnimalService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 
 * @since 2022-04-02
 */
@Service
public class AnimalServiceImpl extends ServiceImpl<AnimalMapper, Animal> implements IAnimalService {

}
