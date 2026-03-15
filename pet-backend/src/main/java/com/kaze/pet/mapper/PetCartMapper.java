package com.kaze.pet.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kaze.pet.entity.PetCart;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface PetCartMapper extends BaseMapper<PetCart> {
    
    @Select("SELECT c.*, p.name as product_name, p.price, p.img, p.stock " +
            "FROM pet_cart c " +
            "LEFT JOIN pet_product p ON c.product_id = p.id " +
            "WHERE c.user_id = #{userId}")
    List<PetCart> findCartsByUserId(@Param("userId") Integer userId);
} 