package com.kaze.pet.service.impl;

import com.kaze.pet.service.ILostService;
import com.kaze.pet.entity.Lost;
import com.kaze.pet.mapper.LostMapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 
 * @since 2022-04-04
 */
@Service
public class LostServiceImpl extends ServiceImpl<LostMapper, Lost> implements ILostService {

}
