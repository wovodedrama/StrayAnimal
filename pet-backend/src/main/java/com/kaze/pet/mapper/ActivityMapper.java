package com.kaze.pet.mapper;

import com.kaze.pet.entity.Activity;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kaze.pet.vo.ActivityNoticeVO;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author 
 * @since 2022-04-04
 */
public interface ActivityMapper extends BaseMapper<Activity> {

    @Select("select * from activity order by id desc limit 5 ")
    List<ActivityNoticeVO> limit(int i);
}
