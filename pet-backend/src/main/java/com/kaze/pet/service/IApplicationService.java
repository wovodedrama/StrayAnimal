package com.kaze.pet.service;

import com.kaze.pet.entity.Application;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 
 * @since 2022-04-02
 */
public interface IApplicationService extends IService<Application> {

    void saveApply(Application application);
}
