package com.kaze.pet.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelWriter;
import java.net.URLEncoder;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.kaze.pet.entity.Animal;
import com.kaze.pet.entity.Application;
import com.kaze.pet.service.IAnimalService;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.kaze.pet.common.Result;
import org.springframework.web.multipart.MultipartFile;
import com.kaze.pet.entity.User;
import com.kaze.pet.utils.TokenUtils;

import com.kaze.pet.service.IApplicationService;

import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author 
 * @since 2022-04-02
 */
@RestController
@RequestMapping("/application")
public class ApplicationController {

    @Resource
    private IApplicationService applicationService;

    @Resource
    private IAnimalService animalService;

    private final String now = DateUtil.now();

    // 宠物领养申请表单提交后走这里
    @PostMapping
    public Result save(@RequestBody Application application) {
        applicationService.saveApply(application);
        return Result.success();
    }

    @PostMapping("/state/{id}/{state}")
    public Result state(@PathVariable Integer id, @PathVariable String state) {
        Application application = applicationService.getById(id);
        application.setState(state);

        QueryWrapper<Application> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("animal_id", application.getAnimalId());
        List<Application> list = applicationService.list(queryWrapper);
        for (Application app : list) {
            app.setState("审核不通过");
            applicationService.updateById(app);
        }

        applicationService.updateById(application);

        Animal animal = animalService.getById(application.getAnimalId());
        animal.setIsAdopt("是");
        animal.setAdopt("不可领养");
        animalService.updateById(animal);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        applicationService.removeById(id);
        return Result.success();
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        applicationService.removeByIds(ids);
        return Result.success();
    }

    @GetMapping
    public Result findAll() {
        return Result.success(applicationService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(applicationService.getById(id));
    }

    @GetMapping("/my")
    public Result my() {
        List<Animal> animals = animalService.list();
        QueryWrapper<Application> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("id");
        User currentUser = TokenUtils.getCurrentUser();
        if (currentUser == null) {
            return Result.success(new ArrayList<>());
        }
        queryWrapper.eq("user_id", currentUser.getId());
        List<Application> applications = applicationService.list(queryWrapper);
        for (Application record : applications) {
            animals.stream().filter(animal -> animal.getId().equals(record.getAnimalId())).findFirst().ifPresent(record::setAnimal);
        }
        return Result.success(applications);
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        List<Animal> animals = animalService.list();
        QueryWrapper<Application> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("id");
        if (!"".equals(name)) {
            queryWrapper.like("name", name);
        }
        Page<Application> page = applicationService.page(new Page<>(pageNum, pageSize), queryWrapper);
        for (Application record : page.getRecords()) {
            animals.stream().filter(animal -> animal.getId().equals(record.getAnimalId())).findFirst().ifPresent(record::setAnimal);
        }
        return Result.success(page);
    }

    /**
    * 导出接口
    */
    @GetMapping("/export")
    public void export(HttpServletResponse response) throws Exception {
        // 从数据库查询出所有的数据
        List<Application> list = applicationService.list();
        // 在内存操作，写出到浏览器
        ExcelWriter writer = ExcelUtil.getWriter(true);

        // 一次性写出list内的对象到excel，使用默认样式，强制输出标题
        writer.write(list, true);

        // 设置浏览器响应的格式
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        String fileName = URLEncoder.encode("application信息表", "UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");

        ServletOutputStream out = response.getOutputStream();
        writer.flush(out, true);
        out.close();
        writer.close();

        }

    /**
     * excel 导入
     * @param file
     * @throws Exception
     */
    @PostMapping("/import")
    public Result imp(MultipartFile file) throws Exception {
        InputStream inputStream = file.getInputStream();
        ExcelReader reader = ExcelUtil.getReader(inputStream);
        // 通过 javabean的方式读取Excel内的对象，但是要求表头必须是英文，跟javabean的属性要对应起来
        List<Application> list = reader.readAll(Application.class);

        applicationService.saveBatch(list);
        return Result.success();
    }

    private User getUser() {
        return TokenUtils.getCurrentUser();
    }

}

