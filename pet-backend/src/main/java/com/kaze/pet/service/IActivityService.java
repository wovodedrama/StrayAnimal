package com.kaze.pet.service;

import com.kaze.pet.entity.Activity;
import com.baomidou.mybatisplus.extension.service.IService;
import com.kaze.pet.vo.ActivityNoticeVO;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 
 * @since 2022-04-04
 */
public interface IActivityService extends IService<Activity> {

    List<ActivityNoticeVO> limit(int i);
}
