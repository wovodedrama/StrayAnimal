package com.kaze.pet.service;

import com.kaze.pet.entity.ArticleKp;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 
 * @since 2022-04-04
 */
public interface IArticleKpService extends IService<ArticleKp> {

    ArticleKp getDetail(Integer id);

    void updateArticle(ArticleKp articleKp);
}
