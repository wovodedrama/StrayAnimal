package com.kaze.pet.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kaze.pet.entity.PetCart;
import com.kaze.pet.entity.PetOrder;
import com.kaze.pet.entity.PetProduct;
import com.kaze.pet.mapper.PetCartMapper;
import com.kaze.pet.mapper.PetOrderMapper;
import com.kaze.pet.mapper.PetProductMapper;
import com.kaze.pet.service.IPetCartService;
import com.kaze.pet.service.IPetOrderService;
import com.kaze.pet.service.IPetProductService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Service
public class PetOrderServiceImpl extends ServiceImpl<PetOrderMapper, PetOrder> implements IPetOrderService {

    @Resource
    private PetProductMapper petProductMapper;

    @Resource
    private PetCartMapper petCartMapper;

    @Resource
    private IPetCartService petCartService;
    @Resource
    private IPetProductService petProductService;

    @Override
    @Transactional
    public boolean createOrder(PetOrder petOrder) {
        // 生成订单号
        petOrder.setOrderNo(generateOrderNo());

        // 获取商品信息
        PetProduct product = petProductMapper.selectById(petOrder.getProductId());
        if (product == null || product.getStock() < petOrder.getQuantity()) {
            // 商品不存在或库存不足
            return false;
        }

        // 设置订单信息
        petOrder.setProductName(product.getName());
        petOrder.setProductPrice(product.getPrice());
        petOrder.setTotalAmount(product.getPrice().multiply(new BigDecimal(petOrder.getQuantity())));
        petOrder.setCreateTime(new Date());
        petOrder.setUpdateTime(new Date());
        petOrder.setStatus("待付款");

        // 减少库存
        product.setStock(product.getStock() - petOrder.getQuantity());
        petProductMapper.updateById(product);

        // 保存订单
        return save(petOrder);
    }

    @Override
    @Transactional
    public boolean createOrderFromCart(Integer userId, String address, String phone) {
        // 获取用户购物车
        List<PetCart> cartItems = petCartService.getUserCarts(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            return false;
        }

        boolean allSuccess = true;

        // 为每个购物车项创建订单
        for (PetCart cartItem : cartItems) {
            PetOrder order = new PetOrder();
            order.setUserId(userId);
            order.setProductId(cartItem.getProductId());
            order.setQuantity(cartItem.getQuantity());
            order.setAddress(address);
            order.setPhone(phone);

            if (!createOrder(order)) {
                allSuccess = false;
            }
        }

        // 清空购物车
        if (allSuccess) {
            petCartService.clearUserCart(userId);
        }

        return allSuccess;
    }

    @Override
    @Transactional
    public boolean payOrder(Integer orderId, String payMethod, String tradeNo) {
        PetOrder order = getById(orderId);
        if (order == null) {
            return false;
        }

        // 只有待付款状态的订单才能付款
        if (!"待付款".equals(order.getStatus())) {
            return false;
        }

        order.setStatus("待发货");
        order.setPayMethod(payMethod);
        order.setTradeNo(tradeNo);
        order.setPayTime(new Date());
        order.setUpdateTime(new Date());

        return updateById(order);
    }

    // 在PetOrderService的shipOrder方法中   
    @Override
    @Transactional
    public boolean shipOrder(Integer id) {
        PetOrder order = this.getById(id);
        if (order == null || !"待发货".equals(order.getStatus())) {
            return false;
        }
        
        // 将状态统一设置为"待收货"
        order.setStatus("待收货");
        order.setUpdateTime(new Date());
        
        return this.updateById(order);
    }

    @Override
    @Transactional
    public boolean completeOrder(Integer orderId) {
        PetOrder order = getById(orderId);
        if (order == null) {
            return false;
        }

        // 只有已发货状态的订单才能完成
        if (!"待收货".equals(order.getStatus())) {
            return false;
        }

        order.setStatus("已完成");
        order.setUpdateTime(new Date());

        return updateById(order);
    }

    @Override
    @Transactional
    public boolean cancelOrder(Integer orderId) {
        PetOrder order = getById(orderId);
        if (order == null) {
            return false;
        }

        // 已完成，已发货的订单不能取消
        if ("已完成".equals(order.getStatus()) || "已发货".equals(order.getStatus())) {
            return false;
        }

        // 恢复库存
        if (!"已取消".equals(order.getStatus())) {
            PetProduct product = petProductMapper.selectById(order.getProductId());
            if (product != null) {
                product.setStock(product.getStock() + order.getQuantity());
                petProductMapper.updateById(product);
            }
        }

        order.setStatus("已取消");
        order.setUpdateTime(new Date());

        return updateById(order);
    }

    @Override
    public Page<PetOrder> findUserOrdersWithProduct(Page page, Integer userId, String status) {
        // 分页查询用户订单
        QueryWrapper<PetOrder> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        if (StringUtils.isNotBlank(status)) {
            queryWrapper.eq("status", status);
        }
        queryWrapper.orderByDesc("id");

        // 先查询订单基本信息
        Page<PetOrder> orderPage = this.page(page, queryWrapper);
        List<PetOrder> orders = orderPage.getRecords();

        // 为每个订单补充产品信息
        for (PetOrder order : orders) {
            // 根据productId查询产品信息
            PetProduct product = petProductService.getById(order.getProductId());
            if (product != null) {
                // 设置产品图片
                order.setImg(product.getImg());
            }
        }

        return orderPage;
    }

    /**
     * 生成订单号
     */
    private String generateOrderNo() {
        // 格式：年月日时分秒+4位随机数
        String dateStr = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String randomStr = String.valueOf((int) ((Math.random() * 9 + 1) * 1000));
        return dateStr + randomStr;
    }
} 