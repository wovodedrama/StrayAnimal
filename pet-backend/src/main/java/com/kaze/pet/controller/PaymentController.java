package com.kaze.pet.controller;

import com.kaze.pet.common.Result;
import com.kaze.pet.entity.PetOrder;
import com.kaze.pet.mapper.PetOrderMapper;
import com.kaze.pet.service.IPaymentService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 支付控制器
 */
@RestController
@RequestMapping("/payment")
public class PaymentController {

    @Resource
    private IPaymentService paymentService;
    
    @Resource
    private PetOrderMapper petOrderMapper;

    /**
     * 创建支付宝支付
     */
    @GetMapping("/alipay/{orderId}")
    public Result createAlipayPayment(@PathVariable Integer orderId) {
        // 获取订单信息
        PetOrder order = petOrderMapper.selectById(orderId);
        if (order == null) {
            return Result.error("404", "订单不存在");
        }
        
        // 只有待付款的订单可以支付
        if (!"待付款".equals(order.getStatus())) {
            return Result.error("400", "订单状态不正确");
        }
        
        // 创建支付链接
        String paymentUrl = paymentService.createAlipayPayment(orderId, order.getTotalAmount());
        if (paymentUrl != null) {
            return Result.success(paymentUrl);
        } else {
            return Result.error("500", "创建支付链接失败");
        }
    }

    /**
     * 创建微信支付
     */
    @GetMapping("/wechat/{orderId}")
    public Result createWechatPayment(@PathVariable Integer orderId) {
        // 获取订单信息
        PetOrder order = petOrderMapper.selectById(orderId);
        if (order == null) {
            return Result.error("404", "订单不存在");
        }
        
        // 只有待付款的订单可以支付
        if (!"待付款".equals(order.getStatus())) {
            return Result.error("400", "订单状态不正确");
        }
        
        // 创建微信支付参数
        Map<String, String> payParams = paymentService.createWechatPayment(orderId, order.getTotalAmount());
        if (payParams != null) {
            return Result.success(payParams);
        } else {
            return Result.error("500", "创建支付参数失败");
        }
    }

    /**
     * 支付宝回调接口
     */
    @PostMapping("/alipay/notify")
    public String alipayNotify(HttpServletRequest request) {
        // 解析支付宝回调参数
        Map<String, String> params = new HashMap<>();
        Map<String, String[]> requestParams = request.getParameterMap();
        for (String name : requestParams.keySet()) {
            String[] values = requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i] : valueStr + values[i] + ",";
            }
            params.put(name, valueStr);
        }
        
        // 处理支付回调
        boolean success = paymentService.handleAlipayCallback(params);
        
        // 返回支付宝回调结果
        return success ? "success" : "fail";
    }

    /**
     * 微信支付回调接口
     */
    @PostMapping("/wechat/notify")
    public String wechatNotify(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 读取微信回调XML数据
        StringBuilder sb = new StringBuilder();
        byte[] buffer = new byte[1024];
        int len;
        while ((len = request.getInputStream().read(buffer)) != -1) {
            sb.append(new String(buffer, 0, len));
        }
        String notifyData = sb.toString();
        
        // 处理微信支付回调
        boolean success = paymentService.handleWechatPayCallback(notifyData);
        
        // 返回微信回调结果
        if (success) {
            return "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>";
        } else {
            return "<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[处理失败]]></return_msg></xml>";
        }
    }

    /**
     * 查询支付状态
     */
    @GetMapping("/status/{orderNo}")
    public Result queryPaymentStatus(@PathVariable String orderNo, @RequestParam String payMethod) {
        String status = paymentService.queryPaymentStatus(orderNo, payMethod);
        return Result.success(status);
    }

    /**
     * 模拟支付成功（仅用于测试）
     */
    @PostMapping("/mock/success/{orderId}")
    public Result mockPaymentSuccess(@PathVariable Integer orderId, @RequestParam String payMethod) {
        // 获取订单信息
        PetOrder order = petOrderMapper.selectById(orderId);
        if (order == null) {
            return Result.error("404", "订单不存在");
        }
        
        // 模拟支付成功
        String tradeNo = "mock_" + System.currentTimeMillis();
        boolean success = order.getPayTime() == null && "待付款".equals(order.getStatus());
        
        if (success) {
            order.setStatus("已付款");
            order.setPayMethod(payMethod);
            order.setTradeNo(tradeNo);
            order.setPayTime(new java.util.Date());
            order.setUpdateTime(new java.util.Date());
            petOrderMapper.updateById(order);
            return Result.success();
        } else {
            return Result.error("400", "订单状态不正确");
        }
    }
} 