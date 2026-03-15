package com.kaze.pet.service.impl;

import com.kaze.pet.entity.Activity;
import com.kaze.pet.mapper.ActivityMapper;
import com.kaze.pet.service.IActivityService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kaze.pet.vo.ActivityNoticeVO;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 
 * @since 2022-04-04
 */
@Service
public class ActivityServiceImpl extends ServiceImpl<ActivityMapper, Activity> implements IActivityService {

    @Resource
    private ActivityMapper activityMapper;
    @Override
    public List<ActivityNoticeVO> limit(int i) {
        return activityMapper.limit(i);
    }
}
