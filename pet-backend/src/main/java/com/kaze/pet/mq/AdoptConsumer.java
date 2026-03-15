package com.kaze.pet.mq;

import com.kaze.pet.config.DeepSeekClient;
import com.kaze.pet.config.RabbitMQConfig;
import com.kaze.pet.dto.AiMessage;
import com.kaze.pet.entity.Animal;
import com.kaze.pet.entity.Application;
import com.kaze.pet.service.IAnimalService;
import com.kaze.pet.service.IApplicationService;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

/**
 * @author Kaze
 * mq中的Consumer（消费消息 Listener）
 */
@Component
public class AdoptConsumer {
    @Autowired
    private IApplicationService applicationService;

    @Autowired
    private IAnimalService animalService;

    @Autowired
    private DeepSeekClient deepSeekClient;

    // 监听ADOPT_QUEUE 风险评估
    @RabbitListener(queues = RabbitMQConfig.ADOPT_QUEUE)
    public void handleApplyMessage(Application application) {
        System.out.println("收到异步领养申请任务" + application);

        String analysis = "AI 评估服务暂时不可用";
        try {
            // 1. 查看宠物基本信息
            Animal animal = animalService.getById(application.getAnimalId());

            // 2. 组装prompt
            String prompt = String.format(
                "用户【%s】申请领养宠物【%s】。\n用户条件：年龄%s，经验：%s，地址：%s，住房性质：%s\n用户理由：%s。\n" +
                    "请分析该申请是否存在风险（如冲动领养、环境不匹配等），并以[风险指数:X][评估意见:Y]的格式回复。其中X的范围：0-3:低风险,4-6:中风险,7-10:高风险",
                application.getName(), animal.getNickname(),
                application.getAge(), application.getExperience(),
                application.getAddress(),application.getHousing(),
                application.getReason()
            );

            // 3. 调用AI
            ArrayList<AiMessage> message = new ArrayList<>();
            message.add(new AiMessage("user",prompt));
            analysis = deepSeekClient.chat(message);
        } catch (Exception e) {
            analysis = "AI 评估失败，请管理员人工核验。";
        } finally {
            application.setAnalysis(analysis);
            applicationService.save(application);
        }
    }
}
