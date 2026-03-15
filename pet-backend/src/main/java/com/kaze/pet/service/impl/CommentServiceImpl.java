package com.kaze.pet.service.impl;

import com.kaze.pet.entity.Comment;
import com.kaze.pet.mapper.CommentMapper;
import com.kaze.pet.service.ICommentService;
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
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment> implements ICommentService {

}
