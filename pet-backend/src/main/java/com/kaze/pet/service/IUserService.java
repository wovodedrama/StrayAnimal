package com.kaze.pet.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kaze.pet.dto.UserDTO;
import com.kaze.pet.dto.UserPasswordDTO;
import com.kaze.pet.entity.User;
/**
 * <p>
 *  服务类
 * </p>
 *
 * @author
 * @since 2022-01-26
 */
public interface IUserService extends IService<User> {

    UserDTO login(UserDTO userDTO);

    User register(UserDTO userDTO);

    void updatePassword(UserPasswordDTO userPasswordDTO);
}
