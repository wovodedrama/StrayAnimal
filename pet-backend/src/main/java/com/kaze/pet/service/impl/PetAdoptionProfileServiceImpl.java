package com.kaze.pet.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kaze.pet.entity.PetAdoptionProfile;
import com.kaze.pet.mapper.PetAdoptionProfileMapper;
import com.kaze.pet.service.IPetAdoptionProfileService;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 用户领养倾向画像表 服务实现类
 * </p>
 *
 * @author sawamura
 * @since 2026-01-12
 */
@Service
public class PetAdoptionProfileServiceImpl extends ServiceImpl<PetAdoptionProfileMapper, PetAdoptionProfile> implements
    IPetAdoptionProfileService {

}
