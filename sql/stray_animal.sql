/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : stray_animal

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 15/03/2026 19:39:05
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时间',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `num` int NULL DEFAULT 0 COMMENT '报名人数',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activity
-- ----------------------------
INSERT INTO `activity` VALUES (6, '征集 | 流浪动物救助故事', '在这个城市里，有些相遇是预谋已久的，而有些相遇，则是一场惊心动魄的营救。\n\n我们总以为是我们在救助它们，但很多时候，是这些毛茸茸的灵魂在治愈满身疲惫的我们。它们曾在大雨中蜷缩，在寒风中翻找垃圾，在每一个路口卑微地等待一份善意。直到那天，你弯下了腰，伸出了手。\n\n【我们想听听你的故事】 从那一刻的“不忍心”，到后来的“离不开”，你们经历了怎样的故事？\n\n是它第一次褪去防备，小心翼翼舔你掌心的温度？\n\n是它从瘦骨嶙峋，变身成为家里“混世魔王”的过程？\n\n还是它在你失落大哭时，默默递过来的一只爪子？\n\n【参与方式】\n\n影像记录：上传 1-2 张它流浪时的旧照，以及现在的生活照。\n\n文字分享：用文字记录下你们相遇的契机、治疗的坎坷，或是它带给你的惊喜。\n\n话题关联：发布时勾选“救助故事”标签。\n\n【关于回馈】 你的故事将被收录在《救助纪实录》中，获得首页高光展示。我们还将选出 10 个最动人的故事，为对应的领养家庭送出“终身健康监测包”。\n\n结语： 救助不是一个人的孤军奋战，而是一群人的微光汇聚。分享你的故事，让更多人相信：领养，真的可以改变命运。', '2022-04-04 13:05:34', 'http://localhost:9090/file/5d2a62bb59fd4c77bf43c62fbc348853.jpg', 3, '南艳湖');
INSERT INTO `activity` VALUES (7, '征集 | 流浪动物救助故事 | 第二季', '流浪，曾是它们唯一的生命状态。 是路边草丛里微弱的呼吸，是深夜翻动垃圾桶的声响，是面对人类时既渴望又恐惧的眼神。\n\n但改变就在那一瞬间发生—— 也许是你递出的一根火腿肠，也许是那个风雨交加的夜晚你撑起的雨伞，或者是你通过我们的系统点下的那一次“申请领养”。\n\n我们需要你的故事： 如果你曾救助过流浪动物，或者你现在的家人正是一只曾经的“流浪毛孩子”，请加入我们的第二季故事征集活动。\n\n你可以分享：\n\n初遇瞬间：你是在哪里发现它的？那时候它的样子是怎样的？\n\n治愈之路：从满身伤痕到毛发顺滑，你们共同经历了哪些难忘的时刻？\n\n性格蜕变：从最初的“社恐”小猫到现在的“粘人精”，它是如何重新建立对人类的信任的？\n\n改变与爱：领养它之后，你的生活发生了哪些意想不到的变化？\n\n征集形式： 请在个人中心点击“发布动态”，带上话题 #流浪动物救助故事S2#，并上传 3-5 张照片（建议包含：救助前 VS 领养后对比照）。\n\n活动奖励：\n勋章奖励：参与用户将获得“生命守护者”限定虚拟勋章。\n首页推荐：优质故事将被推送到“为你推荐”页面的头条展示。\n公益周边：获赞前十名的故事主，我们将送出定制的“流浪猫狗关爱礼包”。\n\n结语： 我们无法改变这个世界，但我们可以改变一个生命的全世界。 期待你的文字，让爱在算法之外，更有温度。', '2022-04-04 13:17:51', 'http://localhost:9090/file/1e94b9f39d60419086bae95ac19304b4.jpg', 5, '市府广场');

-- ----------------------------
-- Table structure for adopt
-- ----------------------------
DROP TABLE IF EXISTS `adopt`;
CREATE TABLE `adopt`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `animal_id` int NOT NULL COMMENT '流浪动物id',
  `adopt_status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '领养状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_adopt_animal`(`animal_id` ASC) USING BTREE,
  CONSTRAINT `fk_adopt_animal` FOREIGN KEY (`animal_id`) REFERENCES `animal` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of adopt
-- ----------------------------

-- ----------------------------
-- Table structure for animal
-- ----------------------------
DROP TABLE IF EXISTS `animal`;
CREATE TABLE `animal`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `nickname` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `sex` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `age` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '动物照片',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '活动范围',
  `status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `sterilization` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `vaccine` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `adopt` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `information` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '其他描述',
  `is_adopt` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `praise` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of animal
-- ----------------------------
INSERT INTO `animal` VALUES (2, '小白', '公', '土松', '12个月', 'http://localhost:9090/file/6c0fb61804cf441f95e9b4103b029d47.jpg', '室外、室内', '健康', '否', '未接种', '可领养', '粘人,需要陪伴,需要经验', '否', 2);
INSERT INTO `animal` VALUES (3, '柴柴', '母', '柴犬', '8周', 'http://localhost:9090/file/be1d647dbf434b06a91ee516639eb906.jpg', '室内', '健康', '是', '已接种', '可领养', '需要经验,精力旺盛,独立,掉毛', '是', 1);
INSERT INTO `animal` VALUES (4, 'kk', '母', '缅因猫', '10周', 'http://localhost:9090/file/81a0100e2e2dc70602b9dcdf49d1c0da.jpg', '室内', '建康', '否', '未接种', '不可领养', '活泼,粘人', '是', 1);
INSERT INTO `animal` VALUES (5, '大耳朵', '公', '中华田园犬', '6个月', 'http://localhost:9090/file/2292c53025974f248715784ed2f1e480.jpg', '室内、室外', '健康', '否', '未接种', '可领养', '需要经验,精力旺盛,活泼,吵闹', '否', 0);
INSERT INTO `animal` VALUES (7, '一月', '公', '异瞳猫咪', '8个月', 'http://localhost:9090/file/5202952872534594b8ff6d5381bcad5c.jpg', '室内', '少许猫藓', '否', '已接种', '不可领养', '粘人,需要陪伴,需要经验', '是', 0);
INSERT INTO `animal` VALUES (8, '花花', '母', '三花', '5个月', 'http://localhost:9090/file/57d4feca55ad47eab378da4d6acf71d3.jpg', '室内', '健康 ', '是', '已接种', '不可领养', '独立', '是', 0);
INSERT INTO `animal` VALUES (9, '小橘', '母', '橘猫', '3个月', 'http://localhost:9090/file/e6dacf6ff2a24663a316cb4497737df1.jpg', '室内', '健康', '否', '未接种', '可领养', '适合新手,独立', '否', 0);
INSERT INTO `animal` VALUES (10, '小黄', '公', '中华田园犬', '6个月', 'http://localhost:9090/file/72e040b2de124a0383e4c6b071cb77c7.jpg', '室内、室外', '健康', '否', '已接种', '可领养', '精力旺盛,适合新手', '否', 0);
INSERT INTO `animal` VALUES (11, '小黑', '公', '中华田园犬', '5个月', 'http://localhost:9090/file/26ddbbad6bb542698ad67eea8152bfc3.jpg', '室内、室外', '健康', '否', '已接种', '可领养', '适合新手,活泼,精力旺盛', '是', 0);
INSERT INTO `animal` VALUES (12, '狸狸', '母', '狸花', '3个月', 'http://localhost:9090/file/eb15c56a471d4a3183bef0610641c7ed.jpg', '室内', '健康', '否', '已接种', '可领养', '独立,适合新手', '否', 0);
INSERT INTO `animal` VALUES (13, '耶耶', '公', '萨摩耶', '1岁', 'http://localhost:9090/file/d04928160ee14f59a825fa626b860cdb.jpg', '室内、室外', '健康', '否', '已接种', '不可领养', '活泼,温顺', '是', 0);
INSERT INTO `animal` VALUES (14, '聪聪', '公', '边牧', '10个月', 'http://localhost:9090/file/ba4056b87c5b4c1bbc4cf0ae40d81bf4.jpg', '室内、室外', '健康', '否', '已接种', '不可领养', '独立', '是', 0);
INSERT INTO `animal` VALUES (15, '小小', '公', '金毛', '4个月', 'http://localhost:9090/file/6524722fba4d474f85dd105c4f0e48d6.jpg', '室内、室外', '健康', '是', '已接种', '可领养', '活泼,精力旺盛,需要经验,掉毛', '是', 0);
INSERT INTO `animal` VALUES (16, '白白', '母', '金吉拉', '6个月', 'http://localhost:9090/file/721505219bcc470eb3577549f5319004.jpg', '室内', '健康', '否', '已接种', '可领养', '粘人,温顺', '否', 1);
INSERT INTO `animal` VALUES (17, '豆丁', '公', '博美', '7个月', 'http://localhost:9090/file/3576ba9f92464608bd7cd88deb5effff.jpg', '室内、室外', '健康', '是', '已接种', '可领养', '活泼', '是', 0);
INSERT INTO `animal` VALUES (18, '卷卷', '公', '泰迪', '12个月', 'http://localhost:9090/file/1e2c31cefe2044b08c64d29699eb472b.jpg', '室内、室外', '健康', '是', '已接种', '不可领养', '活泼', '否', 0);
INSERT INTO `animal` VALUES (19, '土土', '母', '中华田园犬', '2个月', 'http://localhost:9090/file/54e3311fdc1749c1b0419b4d7c829f1a.jpg', '室内、室外', '健康', '否', '未接种', '不可领养', '温顺,活泼,精力旺盛,吵闹', '否', 1);

-- ----------------------------
-- Table structure for application
-- ----------------------------
DROP TABLE IF EXISTS `application`;
CREATE TABLE `application`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `sex` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `age` int NULL DEFAULT NULL COMMENT '年龄',
  `experience` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `pet` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '住址',
  `reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '领养理由',
  `state` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '待审核' COMMENT '审核状态',
  `animal_id` int NULL DEFAULT NULL COMMENT '动物id',
  `user_id` bigint NULL DEFAULT NULL,
  `housing` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `analysis` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT 'AI风险分析',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_application_animal`(`animal_id` ASC) USING BTREE,
  INDEX `fk_application_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_application_animal` FOREIGN KEY (`animal_id`) REFERENCES `animal` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of application
-- ----------------------------
INSERT INTO `application` VALUES (9, '柏原', '女', 15, '无经验', NULL, '15865654532', '南京市', '我和爸妈住，我很喜欢这只小狗，他们答应如果我上学了他们会帮我养', '待审核', 18, 7, '自住', '[风险指数:7][评估意见:该申请存在较高风险，主要基于以下几点：1. 申请人年龄仅15岁，属于未成年人，不具备独立履行领养协议的法律能力与长期经济保障；2. 家庭养宠实际执行者为父母，但父母未直接参与申请，其真实意愿与承诺的可靠性存疑；3. “上学后由父母代养”可能隐含责任转移风险，易因家庭精力不足导致弃养；4. 申请人无养宠经验，且未提及家庭是否具备饲养知识或稳定居住环境。建议：要求父母共同到场签署协议，核实家庭居住条件、养宠历史及具体照护计划，必要时可推荐先参与短期寄养或志愿服务以评估适配性。]');
INSERT INTO `application` VALUES (10, '小白', '女', 15, '无经验', NULL, '15864535986', '南京市', '已得到父母同意，很喜欢这只小狗', '审核不通过', 14, 7, '自住', '[风险指数:7]  \n[评估意见:申请人年龄较小且无饲养经验，虽声称已获父母同意，但需重点核实其家庭实际支持力度（如经济能力、长期照料承诺、居住环境等）。建议：1.要求父母直接参与申请沟通并签署协议；2.安排家庭环境核查（如居住空间、安全措施）；3.提供养宠知识培训并设定试用期。若家庭支持不足或准备不充分，可能存在冲动领养或后续弃养风险。]');
INSERT INTO `application` VALUES (11, '李花', '女', 30, '有经验', NULL, '13756864598', '南京市', '经济独立，有车有房，不婚主义，只想养只小猫静静陪伴。曾养过狸花猫，自然去世。每个月保证1000元的最低支出在宠物上', '审核通过', 8, 7, '自住', '[风险指数:2][评估意见:低风险。申请人经济条件稳定，具备独立饲养能力与养猫经验，且居住环境固定，领养动机明确、理性。主要风险点在于需核实其过往宠物自然去世的具体情况（如年龄、病因），并确认其不婚主义背景下的长期陪伴规划是否稳定。建议补充沟通其应对宠物突发健康问题的预案，并签订正式领养协议。]');
INSERT INTO `application` VALUES (12, '东东', '男', 40, '无经验', NULL, '15865439865', '武汉市', '我会负责任地抚养它长大的', '待审核', 19, 7, '自住', '[风险指数:6][评估意见:中风险。用户年龄稳定，但缺乏饲养经验，且未提供具体居住环境（如住房类型、空间、安全措施等）、家庭成员态度、经济准备及宠物知识学习计划等信息。“负责任抚养”的承诺较为笼统，建议补充资料并开展领养前教育，如要求提供居住环境证明、安排家访或签署科学喂养协议，以降低潜在弃养或照顾不周的风险。]');
INSERT INTO `application` VALUES (13, '张欣', '女', 30, '有经验', NULL, '15632598564', '北京市', '自从独居后感觉家里太安静了，一直很喜欢小土狗，我有稳定的工作和足够的活动空间，能保证每天早晚各遛狗一小时。', '待审核', 11, 7, '自住', '[风险指数:2][评估意见:低风险。申请人年龄30岁、有养宠经验、工作稳定、独居且有明确活动空间规划，领养动机合理（缓解独居孤独感，对土狗有偏好），具备时间与物质基础。主要风险点在于未提供居住环境细节（如是否自有住房/合租、小区宠物政策等），建议补充住房合同或房东同意证明，并确认宠物医疗、应急支出等长期承诺。总体匹配度较高，在核实居住许可后可批准领养。]');
INSERT INTO `application` VALUES (14, '王安', '男', 25, '无经验', NULL, '15896542365', '大连市', '虽然是租房，但我已经征得房东同意，且签了长租合同。我很喜欢猫，想领养一只性格安静的陪我一起生活，我会安装好纱窗。', '待审核', 9, 7, '租房', '[风险指数:5][评估意见:中风险。申请人年龄稳定、租房已获房东同意并签长租合同，且承诺安装纱窗，表明有一定准备。但主要风险在于“无养宠经验”与“希望领养性格安静的猫”之间存在潜在落差——领养后可能因经验不足无法应对猫咪的行为或健康需求，且租房环境变动可能性仍高于自有住房。建议补充措施：1.要求申请人提供房东书面同意证明；2.开展养猫知识线上培训或建议其先参与短期寄养体验；3.优先推荐成年、性格温顺的猫咪，并安排后续回访。]');
INSERT INTO `application` VALUES (15, '杨成', '女', 36, '有经验', NULL, '15896542365', '温州市', '家里之前的狗狗因病去世了，全家人都很想念那种陪伴的感觉。我们有丰富的照料经验，全天都有人在家，不会让宠物感到孤独。', '待审核', 5, 7, '自住', '[风险指数:2][评估意见:低风险。用户具备稳定住房、成熟年龄及宠物照料经验，领养动机源于情感陪伴需求而非冲动，家庭支持与全天陪伴条件优越。主要风险点在于对前宠物离世的情感处理，建议通过沟通确认已做好充分心理准备，并确认居住环境适合新宠物活动后即可批准。]');
INSERT INTO `application` VALUES (16, '李想', '女', 20, '无经验', NULL, '15563248695', '深圳市', '我想在宿舍养只猫，我们室友都挺喜欢的，大家可以一起轮流照顾它，平时也会给它买好吃的。', '待审核', 16, 7, '租房', '[风险指数:8][评估意见:高风险。主要风险点：1. 领养动机存在冲动可能，集体轮流照顾易导致责任分散，长期稳定性存疑；2. 宿舍环境（租房）通常空间有限、人员流动，且可能违反租赁规定；3. 领养人无饲养经验，缺乏对猫咪健康、行为管理的认知；4. 室友共同照顾的承诺未经验证，易因毕业、搬家或意见分歧导致弃养。建议：拒绝或暂缓申请，可建议领养人先通过义工、云养等方式积累经验，待具备稳定独立住房条件后再考虑领养。]');

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_article_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_article_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (10, '如何饲养柴犬?', '饲养柴犬需保证每日充足运动，避免精力过剩拆家。饮食以优质犬粮为主，忌高盐高油人类食物。定期梳理毛发、清洁耳道，春秋换毛季加强护理。从小进行社会化训练，规范行为习惯。定期接种疫苗、体内外驱虫，关注关节健康，每年做一次全面体检', 1, '2026-01-14 10:56:48', '管理员');
INSERT INTO `article` VALUES (11, '猫咪刚到家注意事项', '猫咪刚到家，先准备安静独立角落安置，放好粮、水和猫砂盆。避免强行互动，给它适应时间。24小时内带往宠物医院做基础体检，排查健康问题。暂时不洗澡、不换粮，减少应激。观察饮食、排便情况，若出现异常及时就医。', 7, '2026-01-14 10:57:22', 'atest');

-- ----------------------------
-- Table structure for article_kp
-- ----------------------------
DROP TABLE IF EXISTS `article_kp`;
CREATE TABLE `article_kp`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时间',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `read1` int NULL DEFAULT 0 COMMENT '阅读数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of article_kp
-- ----------------------------
INSERT INTO `article_kp` VALUES (8, '科学领养：开启一场负责任的生命契约', '在城市的钢筋水泥森林中，流浪动物的存在如同斑驳的影子。据不完全统计，全球每年有数千万只犬猫流落在街头。从“流浪”到“回家”，这不仅是地理位置的迁移，更是一次关于生命契约的重塑。然而，满腔的热血并不足以支撑长久的陪伴，真正的领养，始于对“科学匹配”的深刻认知。\n\n一、 领养前的心理建设：你准备好了吗？\n领养宠物绝非一时兴起的冲动。在决定将那个毛茸茸的小生命带回家之前，每个人都应进行一次深度的自我审视。宠物不是玩具，它们拥有长达十余年的寿命，这意味着你需要承诺在未来的四千多个日子里，无论面对搬家、结婚、生子还是职业变动，都不离不弃。\n\n你需要审视自己的生活节奏。一个每日工作十四小时的“加班族”，或许并不适合养一只极度依赖人类陪伴的边境牧羊犬；而一个追求极度洁净的家庭，则需要慎重考虑长毛猫品种带来的掉毛困扰。领养前的心理建设，本质上是个人生活方式与宠物生存需求之间的对等交换。\n\n二、 告别“颜值至上”：性格匹配的重要性\n在传统的领养场景中，人们往往会被宠物的“颜值”所俘虏。然而，外表的迷人往往掩盖了性格的差异。科学领养的核心，在于将“性格匹配”置于审美偏好之上。\n\n每一只宠物都有其独特的“性格标签”。有的猫天生社恐，需要一个安静、少有访客的环境来建立安全感；有的狗精力旺盛，渴望每日在户外驰骋数公里。如果领养人是一个享受静谧时光的阅读者，却领养了一只拆家力度惊人的哈士奇，那么这段关系最终可能走向双输的局面。因此，现代化的领养评估系统开始引入多维度的权重打分：从居住空间的大小、每日可支配的陪伴时间，到对噪音和掉毛的容忍度，这些看似琐碎的指标，实则是决定领养能否成功的基石。\n\n三、 环境与现实的平衡：给它一个稳固的港湾\n除了爱与性格，物质环境是领养成功的硬性保障。住房性质是评估中的重要一环。租房族在领养前必须取得房东的明确同意，并充分考虑到未来搬家时安置宠物的可能性。由于家庭成员的健康状况（如过敏）或邻里关系的敏感性，领养前的环境调研不仅是对宠物的负责，更是对社会关系的尊重。\n\n此外，经济能力的评估不应被视为门槛，而应被视为保障。宠物每年的疫苗接种、驱虫、高质量日粮以及潜在的医疗开支，都需要领养人有稳定的预算支撑。科学领养提倡的是在能力范围内给予宠物最好的照顾，而非盲目地追求昂贵的品种待遇。\n\n四、 领养流程的仪式感：从初审到终审\n正规的领养流程往往包含填写申请表、背景初审、线下互动、甚至家庭回访。这些看似繁琐的步骤，实际上是一道道安全阀。引入人工智能（AI）辅助分析领养理由，可以帮助管理员从数以百计的申请中识别出潜藏的弃养风险或非法买卖倾向。人机协同的审核机制，确保了每一个生命都能精准地流向最适合它的家庭。\n\n五、 结语：让爱止于负责，始于科学\n“用领养代替购买”不仅是一句口号，更是一种文明的进步。当我们不再仅仅因为它的可爱而伸出手，而是因为我们深知彼此的生活轨迹能够重叠而做出承诺时，这份契约才具有了神圣的意义。\n\n每一只流浪过的毛孩子，都值得拥有一个不再流浪的余生。通过科学的评估、精准的匹配以及严谨的审核，我们可以构建一个更加和谐的人宠共生社会。愿每一份领养申请，都能开启一段温暖余生的旅程；愿每一个生命，都能在科学的关怀下，找到那个属于它的、永恒的避风港。', '2026-01-14 10:50:33', 'http://localhost:9090/file/3a70700447594f84ba0f86391f85e278.jpg', 5);
INSERT INTO `article_kp` VALUES (9, '领养代替购买：给生命一次温暖相拥', '随着养宠观念的普及，越来越多人希望家中能有一位毛茸茸的成员相伴。在“买”与“领养”之间，越来越多理性养宠人选择后者。宠物领养不仅是一种爱心选择，更蕴含着科学养宠的诸多学问。本文将从领养价值、正规渠道、准备工作、后续护理四大核心维度，为大家科普宠物领养的关键知识，助力每一次领养都成为双向奔赴的美好约定。\n宠物领养的核心价值，在于“救赎”与“责任”的双重传递。据不完全统计，我国每年新增流浪动物数量超百万，它们或因主人遗弃、或因意外走失，在街头忍受饥饿、疾病与危险。领养行为能直接改善流浪动物的生存境遇，让它们重获稳定的家与关爱。与此同时，领养还能抵制不良宠物繁殖产业。部分非法繁殖场为追求利益，忽视宠物健康，导致大量“星期狗”“星期猫”流入市场，不仅损害消费者权益，更违背动物保护理念。选择领养，就是用实际行动支持理性养宠，推动动物保护事业发展。\n\n选择正规领养渠道，是保障领养顺利的前提。目前主流的正规渠道主要有三类：一是官方或民间动物救助站，这是最常见的领养渠道，救助站的宠物多经过初步救治和性格评估，健康与安全更有保障；二是公益领养平台，包括线上公益组织账号、线下领养日活动，这类渠道能搭建领养人与救助方的直接桥梁，信息透明可追溯；三是宠物医院合作领养点，部分宠物医院会帮助救助的流浪动物寻找领养家庭，且能提供后续医疗支持。需警惕非正规渠道的“免费领养”，避免遭遇“领养诈骗”或领养到携带传染病的宠物。\n\n领养前的充分准备，是避免冲动养宠的关键。物质准备方面，需根据宠物类型提前购置必备用品：犬类需准备食盆、狗粮、牵引绳、狗厕所、窝具等；猫类则需准备猫砂盆、猫砂、猫粮、猫抓板等。同时要对居住环境进行“宠物友好改造”，比如收纳好尖锐物品、药品、电线，封闭阳台和窗户缝隙，防止宠物受伤或走失。心理与责任准备更为重要，要明确宠物寿命可达10-20年，领养后需承担喂养、体检、疫苗、治病等长期责任，不可因搬家、结婚、宠物生病等原因随意抛弃。此外，建议提前了解宠物的性格与习性，比如大型犬需要更多运动空间，胆小的猫需要安静的环境，确保自身生活节奏与宠物需求匹配。\n\n领养后的适应与护理，决定了宠物与家庭的融合质量。宠物刚到新家时，容易因陌生环境产生应激反应，出现躲躲闪闪、食欲不振、乱拉乱尿等情况。此时无需急于互动，可为宠物准备独立的安静角落，让其自行探索适应，同时规律喂食换水，建立安全感。领养后一周内，需带宠物到正规宠物医院进行全面体检，包括传染病筛查、体内外驱虫，后续按时完成疫苗接种。日常护理中，要避免喂食巧克力、洋葱、葡萄等对宠物有毒的人类食物，定期梳理毛发、修剪指甲，每天抽出时间陪伴互动，既能增进感情，也能及时发现宠物的健康异常。\n\n值得强调的是，领养不是“爱心施舍”，而是“责任承诺”。每一只被领养的宠物都曾经历过创伤，它们需要的是长久的陪伴而非短暂的新鲜感。若因特殊情况确实无法继续饲养，应及时联系原救助方或公益组织，协商后续安置方案，坚决杜绝二次抛弃。\n\n领养代替购买，用爱终结流浪。当你打开家门迎接一只流浪宠物时，收获的不仅是一份无条件的陪伴，更是一份生命相互滋养的温暖。希望每一位想要养宠的朋友，都能以理性的态度、负责任的心态选择领养，让更多小生命在关爱中绽放活力。', '2026-01-14 10:56:19', 'http://localhost:9090/file/76f0540a06054bb8b464065d0d7081b1.jpg', 0);

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回复内容',
  `user` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回复时间',
  `pid` int NULL DEFAULT NULL COMMENT '父id',
  `article_id` int NULL DEFAULT NULL COMMENT '文章id',
  `type` int NULL DEFAULT NULL,
  `animal_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_comment_article`(`article_id` ASC) USING BTREE,
  INDEX `fk_comment_parent`(`pid` ASC) USING BTREE,
  CONSTRAINT `fk_comment_parent` FOREIGN KEY (`pid`) REFERENCES `comment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (18, '好可爱！', 'atest', '2026-01-13 14:23:26', NULL, 19, 1, NULL);
INSERT INTO `comment` VALUES (19, '可爱！', 'atest', '2026-01-13 14:29:04', NULL, 19, 1, NULL);
INSERT INTO `comment` VALUES (20, '非常有帮助！', 'atest', '2026-01-14 10:57:39', NULL, 10, 2, NULL);

-- ----------------------------
-- Table structure for donate
-- ----------------------------
DROP TABLE IF EXISTS `donate`;
CREATE TABLE `donate`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '捐款人',
  `goods` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '捐赠物资',
  `time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '捐款事件',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of donate
-- ----------------------------
INSERT INTO `donate` VALUES (1, '张三', '牛奶', '2022-04-04 11:58:21');

-- ----------------------------
-- Table structure for feed
-- ----------------------------
DROP TABLE IF EXISTS `feed`;
CREATE TABLE `feed`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '环境照片1',
  `img2` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '环境照片2',
  `img3` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '环境照片3',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `information` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '相关描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of feed
-- ----------------------------
INSERT INTO `feed` VALUES (2, 'http://localhost:9090/file/ce0135349fef4604aaa307edfabbfd50.jpg', 'http://localhost:9090/file/9414fa68da8543ffba7142dd4e4d5733.jpg', 'http://localhost:9090/file/883e5ce433e34f5cb269d7e727c4f04b.jpg', '从套公园', '投放粮食');
INSERT INTO `feed` VALUES (3, 'http://localhost:9090/file/53f1f6b896a04cf3952b796bd7a39d33.jpg', 'http://localhost:9090/file/d42dc880e2524423b020b91aa6f21ac2.jpg', 'http://localhost:9090/file/face80313032457f9883009cd6829e62.jpg', '公园', '投放粮食');
INSERT INTO `feed` VALUES (4, 'http://localhost:9090/file/e2f202cb3a19491fb3bb79cf142e8146.jpg', 'http://localhost:9090/file/7df0b18e91984a87aef815ac87e4dfb2.jpg', 'http://localhost:9090/file/4a7b7e2e98324c8ca1e1825e42fa2d49.jpg', '小区楼下', '救助喂养');
INSERT INTO `feed` VALUES (5, 'http://localhost:9090/file/152ad0834bfd46d6b3a196bae407bb25.jpg', 'http://localhost:9090/file/9ed787e3c338417e9b697589b8c2fb81.jpg', 'http://localhost:9090/file/5bf9b5b53b9e4aaba004f98d809107da.jpg', '医院楼下', '救助喂养');

-- ----------------------------
-- Table structure for lost
-- ----------------------------
DROP TABLE IF EXISTS `lost`;
CREATE TABLE `lost`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `nickname` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '走失宠物名字',
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '种类',
  `sex` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  `person` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '联系方式',
  `status1` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '已丢失/带领回',
  `status2` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '找回状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of lost
-- ----------------------------
INSERT INTO `lost` VALUES (1, '三毛', '狗', '公', '李华', '13900887766', '已丢失', '未找到');
INSERT INTO `lost` VALUES (2, '小米', '猫', '母', '小邓', '13988997766', '已丢失', '未找到');

-- ----------------------------
-- Table structure for pet_adoption_profile
-- ----------------------------
DROP TABLE IF EXISTS `pet_adoption_profile`;
CREATE TABLE `pet_adoption_profile`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '关联用户ID',
  `daily_time` tinyint NULL DEFAULT 0 COMMENT '每天可陪伴时长：0-少于2小时，1-2到5小时，2-5小时以上',
  `activity_level` tinyint NULL DEFAULT 0 COMMENT '生活节奏/运动量：0-低(居家静止)，1-中(偶尔散步)，2-高(经常户外)',
  `experience_level` tinyint NULL DEFAULT 0 COMMENT '养宠经验：0-新手小白，1-有一定经验，2-资深大佬',
  `accept_shedding` tinyint(1) NULL DEFAULT 1 COMMENT '是否接受掉毛：0-不接受，1-接受',
  `accept_noise` tinyint(1) NULL DEFAULT 1 COMMENT '是否接受吵闹：0-喜欢安静，1-不介意',
  `space_size` tinyint NULL DEFAULT 0 COMMENT '居住空间：0-公寓/开间，1-普通套房，2-自带院子',
  `pref_personality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '倾向的宠物性格关键词(逗号分隔，如：温顺,独立)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户领养倾向画像表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pet_adoption_profile
-- ----------------------------
INSERT INTO `pet_adoption_profile` VALUES (1, 2, 0, 1, 1, 1, 1, 0, '温顺', NULL, NULL);
INSERT INTO `pet_adoption_profile` VALUES (2, 7, 1, 1, 0, 1, 1, 1, '温顺,粘人', NULL, NULL);

-- ----------------------------
-- Table structure for pet_cart
-- ----------------------------
DROP TABLE IF EXISTS `pet_cart`;
CREATE TABLE `pet_cart`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint NOT NULL,
  `product_id` int NOT NULL COMMENT '商品ID',
  `quantity` int NULL DEFAULT 1 COMMENT '商品数量',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_product_index`(`user_id` ASC, `product_id` ASC) USING BTREE COMMENT '同一用户同一商品只能有一条记录',
  INDEX `fk_cart_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `pet_product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of pet_cart
-- ----------------------------

-- ----------------------------
-- Table structure for pet_order
-- ----------------------------
DROP TABLE IF EXISTS `pet_order`;
CREATE TABLE `pet_order`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NULL DEFAULT NULL,
  `product_id` int NOT NULL COMMENT '商品ID',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品名称',
  `product_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '商品价格',
  `quantity` int NULL DEFAULT 1 COMMENT '购买数量',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '订单总金额',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货地址',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '待付款' COMMENT '订单状态（待付款/已付款/已发货/已完成/已取消）',
  `pay_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '未支付' COMMENT '支付方式（支付宝/微信支付/未支付）',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `trade_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方支付流水号',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_order_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_order_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of pet_order
-- ----------------------------
INSERT INTO `pet_order` VALUES (1, '202504211521435376', 1, 2, '宠物高级猫粮', 88.00, 1, 88.00, '123', '12312', '待发货', 'wechat', '2025-04-21 16:28:44', 'MOCK_1745224123615', '2025-04-21 15:21:44', '2025-04-21 16:28:44');
INSERT INTO `pet_order` VALUES (2, '202504211521473478', 1, 1, '猫咪玩具套装', 39.90, 1, 39.90, '12312', '123123', '已完成', 'alipay', '2025-04-21 15:27:01', 'MOCK_1745220421203', '2025-04-21 15:21:47', '2025-04-22 16:56:21');
INSERT INTO `pet_order` VALUES (4, '202504221633155007', 1, 2, '宠物高级猫粮', 88.00, 1, 88.00, '安徽合肥', '13988997788', '待收货', 'wechat', '2025-04-22 16:33:32', 'MOCK_1745310811748', '2025-04-22 16:33:15', '2025-04-22 16:33:32');
INSERT INTO `pet_order` VALUES (7, '202504271000109606', 6, 11, '宠物玩具', 98.00, 1, 98.00, 'test', '15888888888', '待发货', 'alipay', '2025-04-27 10:07:06', 'MOCK_1745719519142', '2025-04-27 10:00:11', '2025-04-27 10:07:06');
INSERT INTO `pet_order` VALUES (8, '202504271000151174', 6, 11, '宠物玩具', 98.00, 1, 98.00, 'test', '15888888888', '待发货', 'alipay', '2025-04-27 10:02:51', 'MOCK_1745719331990', '2025-04-27 10:00:16', '2025-04-27 10:02:51');
INSERT INTO `pet_order` VALUES (9, '202601130933292382', 7, 10, '医疗', 34.00, 1, 34.00, '111', '14534256784', '待付款', '未支付', NULL, NULL, '2026-01-13 09:33:30', '2026-01-13 09:33:30');
INSERT INTO `pet_order` VALUES (10, '202601141503542682', 7, 11, '宠物玩具', 98.00, 1, 98.00, 'test', '12365458965', '待发货', 'alipay', '2026-01-14 15:05:30', 'MOCK_1768374329577', '2026-01-14 15:03:55', '2026-01-14 15:05:30');

-- ----------------------------
-- Table structure for pet_product
-- ----------------------------
DROP TABLE IF EXISTS `pet_product`;
CREATE TABLE `pet_product`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL COMMENT '商品价格',
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品描述',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品图片',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of pet_product
-- ----------------------------
INSERT INTO `pet_product` VALUES (4, '狗粮', 78.00, '食品', 109, '食品食品', 'http://localhost:9090/file/eac1c993c01a4dff8675461dad69bb2b.jpg', '上架', '2025-04-22 17:14:36');
INSERT INTO `pet_product` VALUES (5, '宠物食盆', 11.00, '日用品', 100, '日用品日用品', 'http://localhost:9090/file/7e9938492ebc407491895350b8d86736.jpg', '上架', '2025-04-22 17:14:55');
INSERT INTO `pet_product` VALUES (6, '玩具', 12.00, '玩具', 100, '玩具玩具', 'http://localhost:9090/file/017fbc895eed4dae81389365579333bd.jpg', '上架', '2025-04-22 17:15:45');
INSERT INTO `pet_product` VALUES (7, '医疗', 23.00, '医疗保健', 300, '医疗医疗', 'http://localhost:9090/file/d0235e2c0cd84b9aa8184b8651832ac7.jpg', '上架', '2025-04-22 17:16:17');
INSERT INTO `pet_product` VALUES (8, '智能喝水器', 34.00, '日用品', 100, '日用品日用品', 'http://localhost:9090/file/8a052def78c44f0fbbf58c49ce6dda64.jpg', '上架', '2025-04-22 17:14:55');
INSERT INTO `pet_product` VALUES (9, '玩具', 56.00, '玩具', 100, '玩具玩具', 'http://localhost:9090/file/017fbc895eed4dae81389365579333bd.jpg', '上架', '2025-04-22 17:15:45');
INSERT INTO `pet_product` VALUES (10, '医疗', 34.00, '医疗保健', 299, '医疗医疗', 'http://localhost:9090/file/02c19eb9d56645fb8af816e59c2e4eb1.jpg', '上架', '2025-04-22 17:16:17');
INSERT INTO `pet_product` VALUES (11, '宠物玩具', 98.00, '玩具', 97, '玩具玩具玩具玩具', 'http://localhost:9090/file/667e038b7928414dbc5fb75fd6e45192.jpg', '上架', '2025-04-22 17:14:01');

-- ----------------------------
-- Table structure for rescue
-- ----------------------------
DROP TABLE IF EXISTS `rescue`;
CREATE TABLE `rescue`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '照片',
  `person` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '联系方式',
  `information` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '相关描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rescue
-- ----------------------------
INSERT INTO `rescue` VALUES (1, '救助1号', '市府广场', 'http://localhost:9090/file/c8760c6772934256aa516e5cb3a102ef.jpg', '李约瑟', '13977886699', '救助');
INSERT INTO `rescue` VALUES (2, '流浪之家', '双百广场', 'http://localhost:9090/file/e1ce9d42a7e947249a611edb423552ef.jpg', '李先生', '15698654896', '救助');
INSERT INTO `rescue` VALUES (3, '爱心小窝', '尚比村', 'http://localhost:9090/file/dc4d9419f6a349ce8b97b06f9706ffa6.jpg', '张先生', '18956489756', '救助');
INSERT INTO `rescue` VALUES (4, '爱心之家', '翰林路', 'http://localhost:9090/file/039d0670ea544a4b96a7d37bbf2e817d.jpg', '杨先生', '15623456745', '救助');
INSERT INTO `rescue` VALUES (5, '可爱之家', '赵王大街', 'http://localhost:9090/file/b1ac91524bf44b33a2e9ceab51369bc4.jpg', '孙洁', '19656485625', '救助');

-- ----------------------------
-- Table structure for salvation
-- ----------------------------
DROP TABLE IF EXISTS `salvation`;
CREATE TABLE `salvation`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `information` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '情况描述',
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '现场照片',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '地点',
  `time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '发现时间',
  `person` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '联系方式',
  `state` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '未解决' COMMENT '解决状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of salvation
-- ----------------------------
INSERT INTO `salvation` VALUES (1, '小野猫', 'http://localhost:9090/file/953a7da6404d4d438a88f19657fdfa03.jpg', '市中心', '2022-04-04 07:00:00', '张三', '13988990077', '已解决');
INSERT INTO `salvation` VALUES (2, '小野猫', 'http://localhost:9090/file/6ab2e20eae204c78b5dc50d113cb897f.jpg', '科技馆', '2022-04-04 10:17:47', '张飞', '13088997766', '未解决');
INSERT INTO `salvation` VALUES (3, '眼部周围肿胀', 'http://localhost:9090/file/cb6c87ef1df14da7beb6b3067922ca1d.jpg', '食堂门口', '2025-12-03 09:09:00', '杨先生', '15634569856', '已解决');
INSERT INTO `salvation` VALUES (9, '毛发打结', 'http://localhost:9090/file/41d78be1286945b1b03f54f349beb09d.jpg', '赵王大街', '2026-01-08 16:13:00', '王二', '15698756983', '未解决');
INSERT INTO `salvation` VALUES (10, '身上有猫藓', 'http://localhost:9090/file/fa82b81f068747ddb078eff2c2f250f9.jpg', '尚壁镇', '2026-01-14 12:06:00', '李四', '17659654789', '未解决');
INSERT INTO `salvation` VALUES (11, '脱水', 'http://localhost:9090/file/4ecb5a51bb3945ada2dfc6b0c8d17bc2.jpg', '翰林路', '2026-01-08 16:08:00', '张六', '15965496583', '已解决');
INSERT INTO `salvation` VALUES (12, '身上上有血迹', 'http://localhost:9090/file/63ec9eb60fa14244b0d93891fc638a0e.jpg', '公司门口', '2025-01-23 13:00:00', '周四', '15789654897', '已解决');

-- ----------------------------
-- Table structure for sterilization
-- ----------------------------
DROP TABLE IF EXISTS `sterilization`;
CREATE TABLE `sterilization`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `animal_id` int NULL DEFAULT NULL COMMENT '流浪动物id',
  `catch1` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '捕捉状态',
  `sterilization` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '绝育状态',
  `release1` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '放生状态',
  `vaccine` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '疫苗状态',
  `animal_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_sterilization_animal`(`animal_id` ASC) USING BTREE,
  CONSTRAINT `fk_sterilization_animal` FOREIGN KEY (`animal_id`) REFERENCES `animal` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sterilization
-- ----------------------------

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '内容',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('user', 'el-icon-user', 'icon');
INSERT INTO `sys_dict` VALUES ('house', 'el-icon-house', 'icon');
INSERT INTO `sys_dict` VALUES ('menu', 'el-icon-menu', 'icon');
INSERT INTO `sys_dict` VALUES ('s-custom', 'el-icon-s-custom', 'icon');
INSERT INTO `sys_dict` VALUES ('s-grid', 'el-icon-s-grid', 'icon');
INSERT INTO `sys_dict` VALUES ('document', 'el-icon-document', 'icon');
INSERT INTO `sys_dict` VALUES ('coffee', 'el-icon-coffee\r\n', 'icon');
INSERT INTO `sys_dict` VALUES ('s-marketing', 'el-icon-s-marketing', 'icon');

-- ----------------------------
-- Table structure for sys_file
-- ----------------------------
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名称',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件类型',
  `size` bigint NULL DEFAULT NULL COMMENT '文件大小(kb)',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下载链接',
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件md5',
  `is_delete` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除',
  `enable` tinyint(1) NULL DEFAULT 1 COMMENT '是否禁用链接',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 123 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_file
-- ----------------------------
INSERT INTO `sys_file` VALUES (37, 'keyboard.jpg', 'jpg', 169, 'http://localhost:9090/file/b8f9f9da831e458080a7907745dd08bf.jpg', '25f8eadc1cf2150cb557cc494354c499', 0, 1);
INSERT INTO `sys_file` VALUES (38, 'qq音乐.png', 'png', 445, 'http://localhost:9090/file/607a2175097b4164905bfb316f4b135d.png', '793fd534fa705475eb3358f68c87ec68', 0, 1);
INSERT INTO `sys_file` VALUES (39, 'courgette.log', 'log', 0, 'http://localhost:9090/file/7716acb75ec042baa0060e07e16c75ea.log', 'd41d8cd98f00b204e9800998ecf8427e', 0, 1);
INSERT INTO `sys_file` VALUES (40, 'mp.jpg', 'jpg', 32, 'http://localhost:9090/file/70882b6b03914e38b4b6a7e025bedd89.jpg', 'cb887a9d64563352edce80cf50296cc5', 0, 1);
INSERT INTO `sys_file` VALUES (41, 'spring.png', 'png', 4, 'http://localhost:9090/file/94112e8435cb4406bcbb8027c68075b1.png', '3e0089a8778351ae5c7bde6df7eb61fe', 0, 1);
INSERT INTO `sys_file` VALUES (42, 'manage.jpg', 'jpg', 74, 'http://localhost:9090/file/81dc2c4e43dd4470b7aa68e834a6710b.jpg', '16a137ade22505a118af8a386c8b4a51', 0, 1);
INSERT INTO `sys_file` VALUES (43, 'wx.jpg', 'jpg', 61, 'http://localhost:9090/file/24c8262ba9a3400da653cd46ce991b3d.jpg', '9b6af0e36fde3ae55f06e225a110d103', 0, 1);
INSERT INTO `sys_file` VALUES (44, 'coffee2.jpg', 'jpg', 119, 'http://localhost:9090/file/c774308c39a94ae78e77fa1f18f9ebe8.jpg', '748e2639d25445651172798cebf169ab', 0, 1);
INSERT INTO `sys_file` VALUES (45, 'java.png', 'png', 544, 'http://localhost:9090/file/95de6cb968744e4cbbe19d424d99af59.png', '06f01286858e8e4ed47746fbd194c0ae', 0, 1);
INSERT INTO `sys_file` VALUES (46, '1.jpg', 'jpg', 13, 'http://localhost:9090/file/17cfd74665364bdaa8632fe3a7afd8a2.jpg', 'd4c3baabf8b467c225b39207fea618b6', 0, 1);
INSERT INTO `sys_file` VALUES (47, 'boot.png', 'png', 423, 'http://localhost:9090/file/abae37ca1a6a4bc2acecdddaed9af142.png', 'c4f07569176f8d71b5c852587035dbaa', 0, 1);
INSERT INTO `sys_file` VALUES (48, '0e020e1337474a93ba3b43a75b2890ee.doc', 'doc', 47, 'http://localhost:9090/file/ecdd73c8d44b4b948e81cd4df8f2c59a.doc', '9ace4fac24420f85c753aa663009edb4', 1, 1);
INSERT INTO `sys_file` VALUES (49, '3.jpg', 'jpg', 22, 'http://localhost:9090/file/a2d2da19bde9429c96d2e627b0f03a64.jpg', 'fb96c7d2e7f999f5e604cdfaa62ba9b6', 0, 1);
INSERT INTO `sys_file` VALUES (50, '0e020e1337474a93ba3b43a75b2890ee.doc', 'doc', 47, 'http://localhost:9090/file/ecdd73c8d44b4b948e81cd4df8f2c59a.doc', '9ace4fac24420f85c753aa663009edb4', 1, 1);
INSERT INTO `sys_file` VALUES (51, 'SpringBoot集成支付宝沙箱支付.docx', 'docx', 1762, 'http://localhost:9090/file/cd0c67fcbb1a419aab7f1deaaa566f40.docx', '56f866f2e95e515deef34e62b03d8193', 0, 1);
INSERT INTO `sys_file` VALUES (52, 'p538187208.jpg', 'jpg', 221, 'http://localhost:9090/file/bbe13e7e29c94e8d8eff233d289741d3.jpg', '737061eeafa267e3af608f983fff892a', 0, 1);
INSERT INTO `sys_file` VALUES (53, 'p538306328.jpg', 'jpg', 209, 'http://localhost:9090/file/83fd32c1d5ff47f1b4fdabae6fcb753c.jpg', '1941d0cbdb3a9e683921caf2b10396a8', 0, 1);
INSERT INTO `sys_file` VALUES (54, 'p538359297.jpg', 'jpg', 104, 'http://localhost:9090/file/12ee2a9b1e3e474d985e527e8ef7b127.jpg', 'a02fe4f5faad4d907113fbbf8736c195', 0, 1);
INSERT INTO `sys_file` VALUES (55, '109951166671773481.jpg', 'jpg', 44, 'http://localhost:9090/file/7fb997978b95479aa3e53f459238fc8b.jpg', '56a572901fe4a518173143c79d0a2f96', 0, 1);
INSERT INTO `sys_file` VALUES (56, 'p538515362.jpg', 'jpg', 89, 'http://localhost:9090/file/840647717fb4487cb4a2d9e1c54228ea.jpg', '89d9271ce23e02ddaf5701504237e76c', 0, 1);
INSERT INTO `sys_file` VALUES (57, 'p538779436.jpg', 'jpg', 109, 'http://localhost:9090/file/0f93c3ce2daa4c28b6b6e98ebd4cd802.jpg', '57a78ba0bd40da1fa62b22be2d6ed787', 0, 1);
INSERT INTO `sys_file` VALUES (58, '109951166509784238.jpg', 'jpg', 48, 'http://localhost:9090/file/f0c6c9006876481885afb796e252ef48.jpg', '2dd7e11dc6befe47abd09f28f6451821', 0, 1);
INSERT INTO `sys_file` VALUES (59, '109951166509784238.jpg', 'jpg', 48, 'http://localhost:9090/file/f0c6c9006876481885afb796e252ef48.jpg', '2dd7e11dc6befe47abd09f28f6451821', 0, 1);
INSERT INTO `sys_file` VALUES (60, '109951166509784238.jpg', 'jpg', 48, 'http://localhost:9090/file/f0c6c9006876481885afb796e252ef48.jpg', '2dd7e11dc6befe47abd09f28f6451821', 0, 1);
INSERT INTO `sys_file` VALUES (61, 'p538359297.jpg', 'jpg', 104, 'http://localhost:9090/file/12ee2a9b1e3e474d985e527e8ef7b127.jpg', 'a02fe4f5faad4d907113fbbf8736c195', 0, 1);
INSERT INTO `sys_file` VALUES (62, 'p538203308.jpg', 'jpg', 126, 'http://localhost:9090/file/886d7e8105f94b8b9984606acdc77384.jpg', '8f1b6e5de88a499d1bdb1411b8e74ce4', 0, 1);
INSERT INTO `sys_file` VALUES (63, 'p538306328.jpg', 'jpg', 209, 'http://localhost:9090/file/83fd32c1d5ff47f1b4fdabae6fcb753c.jpg', '1941d0cbdb3a9e683921caf2b10396a8', 0, 1);
INSERT INTO `sys_file` VALUES (64, 'p538779436.jpg', 'jpg', 109, 'http://localhost:9090/file/0f93c3ce2daa4c28b6b6e98ebd4cd802.jpg', '57a78ba0bd40da1fa62b22be2d6ed787', 0, 1);
INSERT INTO `sys_file` VALUES (65, 'p538779436.jpg', 'jpg', 109, 'http://localhost:9090/file/0f93c3ce2daa4c28b6b6e98ebd4cd802.jpg', '57a78ba0bd40da1fa62b22be2d6ed787', 0, 1);
INSERT INTO `sys_file` VALUES (66, 'p538306328.jpg', 'jpg', 209, 'http://localhost:9090/file/83fd32c1d5ff47f1b4fdabae6fcb753c.jpg', '1941d0cbdb3a9e683921caf2b10396a8', 0, 1);
INSERT INTO `sys_file` VALUES (67, 'p538359297.jpg', 'jpg', 104, 'http://localhost:9090/file/12ee2a9b1e3e474d985e527e8ef7b127.jpg', 'a02fe4f5faad4d907113fbbf8736c195', 0, 1);
INSERT INTO `sys_file` VALUES (68, 'p538306328.jpg', 'jpg', 209, 'http://localhost:9090/file/83fd32c1d5ff47f1b4fdabae6fcb753c.jpg', '1941d0cbdb3a9e683921caf2b10396a8', 0, 1);
INSERT INTO `sys_file` VALUES (69, 'p538203308.jpg', 'jpg', 126, 'http://localhost:9090/file/886d7e8105f94b8b9984606acdc77384.jpg', '8f1b6e5de88a499d1bdb1411b8e74ce4', 0, 1);
INSERT INTO `sys_file` VALUES (70, 'p538306328.jpg', 'jpg', 209, 'http://localhost:9090/file/83fd32c1d5ff47f1b4fdabae6fcb753c.jpg', '1941d0cbdb3a9e683921caf2b10396a8', 0, 1);
INSERT INTO `sys_file` VALUES (71, 'p538187208.jpg', 'jpg', 221, 'http://localhost:9090/file/bbe13e7e29c94e8d8eff233d289741d3.jpg', '737061eeafa267e3af608f983fff892a', 0, 1);
INSERT INTO `sys_file` VALUES (72, 'p538779436.jpg', 'jpg', 109, 'http://localhost:9090/file/0f93c3ce2daa4c28b6b6e98ebd4cd802.jpg', '57a78ba0bd40da1fa62b22be2d6ed787', 0, 1);
INSERT INTO `sys_file` VALUES (73, 'p538203308.jpg', 'jpg', 126, 'http://localhost:9090/file/886d7e8105f94b8b9984606acdc77384.jpg', '8f1b6e5de88a499d1bdb1411b8e74ce4', 0, 1);
INSERT INTO `sys_file` VALUES (74, 'p538359297.jpg', 'jpg', 104, 'http://localhost:9090/file/12ee2a9b1e3e474d985e527e8ef7b127.jpg', 'a02fe4f5faad4d907113fbbf8736c195', 0, 1);
INSERT INTO `sys_file` VALUES (75, 'p538306328.jpg', 'jpg', 209, 'http://localhost:9090/file/83fd32c1d5ff47f1b4fdabae6fcb753c.jpg', '1941d0cbdb3a9e683921caf2b10396a8', 0, 1);
INSERT INTO `sys_file` VALUES (76, 'p538515362.jpg', 'jpg', 89, 'http://localhost:9090/file/840647717fb4487cb4a2d9e1c54228ea.jpg', '89d9271ce23e02ddaf5701504237e76c', 0, 1);
INSERT INTO `sys_file` VALUES (77, '77.png', 'png', 6442, 'http://localhost:9090/file/d25f29bfcfa945699ba43b86ba022664.png', '2abeff668cc22d82af3a82f7a504c0bd', 0, 1);
INSERT INTO `sys_file` VALUES (78, 'bridge-3825439_960_720.webp', 'webp', 77, 'http://localhost:9090/file/b7f128f8b77a408c965f2c0480a538a8.webp', '0d3839f085078f34c159794e99b101c1', 0, 1);
INSERT INTO `sys_file` VALUES (79, '222.png', 'png', 1175, 'http://localhost:9090/file/78ba9a04853845dd819d442132cec41b.png', '1cf035b8f674c68a9fb999df10c49210', 0, 1);
INSERT INTO `sys_file` VALUES (80, '2.jpg', 'jpg', 61, 'http://localhost:9090/file/fd5da45053e34f6eaca7d8dfe7893e1d.jpg', '698f208b46b5b780a231593517b6b26e', 0, 1);
INSERT INTO `sys_file` VALUES (81, '109951166509784238.jpg', 'jpg', 48, 'http://localhost:9090/file/f0c6c9006876481885afb796e252ef48.jpg', '2dd7e11dc6befe47abd09f28f6451821', 0, 1);
INSERT INTO `sys_file` VALUES (82, '109951166671773481.jpg', 'jpg', 44, 'http://localhost:9090/file/7fb997978b95479aa3e53f459238fc8b.jpg', '56a572901fe4a518173143c79d0a2f96', 0, 1);
INSERT INTO `sys_file` VALUES (83, '2.jpg', 'jpg', 61, 'http://localhost:9090/file/fd5da45053e34f6eaca7d8dfe7893e1d.jpg', '698f208b46b5b780a231593517b6b26e', 0, 1);
INSERT INTO `sys_file` VALUES (84, '2.jpg', 'jpg', 61, 'http://localhost:9090/file/fd5da45053e34f6eaca7d8dfe7893e1d.jpg', '698f208b46b5b780a231593517b6b26e', 0, 1);
INSERT INTO `sys_file` VALUES (85, '2.jpg', 'jpg', 61, 'http://localhost:9090/file/fd5da45053e34f6eaca7d8dfe7893e1d.jpg', '698f208b46b5b780a231593517b6b26e', 0, 1);
INSERT INTO `sys_file` VALUES (86, '2.jpg', 'jpg', 61, 'http://localhost:9090/file/fd5da45053e34f6eaca7d8dfe7893e1d.jpg', '698f208b46b5b780a231593517b6b26e', 0, 1);
INSERT INTO `sys_file` VALUES (87, '3.jpg', 'jpg', 53, 'http://localhost:9090/file/0601b66bb2324a278664c0cda7c25668.jpg', 'aab7e79dc76783ab67dd5359b2b428d0', 0, 1);
INSERT INTO `sys_file` VALUES (88, '109951166950559389.jpg', 'jpg', 18, 'http://localhost:9090/file/6e8f37f7009e4d18a72e1970d2762faf.jpg', '773d42f1cc4fc27f29388571bf3bc8b3', 0, 1);
INSERT INTO `sys_file` VALUES (89, '截屏2022-12-09 上午9.36.55.png', 'png', 183, 'http://localhost:9090/file/080f009b31cb4a3fa5a6a9ab56d2fe1d.png', '5818f3264d53eca6b37c838b167f7b79', 0, 1);
INSERT INTO `sys_file` VALUES (90, '截屏2023-04-19 下午2.28.27.png', 'png', 157, 'http://localhost:9090/file/1a2020635b2449618c0dc6d7d5e65b5e.png', '34217e488d26b5c209a498e7bd8e3655', 0, 1);
INSERT INTO `sys_file` VALUES (91, '截屏2022-12-11 下午11.53.58.png', 'png', 49, 'http://localhost:9090/file/93b54f084ab1485a8acff3200d6b9fe7.png', '1d7c978a0ab76ab446091dd563233022', 0, 1);
INSERT INTO `sys_file` VALUES (92, '截屏2023-08-20 上午11.05.30.png', 'png', 39, 'http://localhost:9090/file/a561823791374c6e9b403bfc3f3611db.png', '33815763be63bc95cb01f430dd0eeefc', 0, 1);
INSERT INTO `sys_file` VALUES (93, '截屏2022-12-09 上午9.36.55.png', 'png', 183, 'http://localhost:9090/file/080f009b31cb4a3fa5a6a9ab56d2fe1d.png', '5818f3264d53eca6b37c838b167f7b79', 0, 1);
INSERT INTO `sys_file` VALUES (94, 'down.jpeg', 'jpeg', 84, 'http://localhost:9090/file/e768c90dbec34eb89f7a3e724d132ee8.jpeg', '2ad58d683db074e172f29c36d932c66f', 0, 1);
INSERT INTO `sys_file` VALUES (95, 'down.jpeg', 'jpeg', 84, 'http://localhost:9090/file/e768c90dbec34eb89f7a3e724d132ee8.jpeg', '2ad58d683db074e172f29c36d932c66f', 0, 1);
INSERT INTO `sys_file` VALUES (96, 'down.jpeg', 'jpeg', 84, 'http://localhost:9090/file/e768c90dbec34eb89f7a3e724d132ee8.jpeg', '2ad58d683db074e172f29c36d932c66f', 0, 1);
INSERT INTO `sys_file` VALUES (97, 'down.jpeg', 'jpeg', 84, 'http://localhost:9090/file/e768c90dbec34eb89f7a3e724d132ee8.jpeg', '2ad58d683db074e172f29c36d932c66f', 0, 1);
INSERT INTO `sys_file` VALUES (98, 'down.jpeg', 'jpeg', 84, 'http://localhost:9090/file/e768c90dbec34eb89f7a3e724d132ee8.jpeg', '2ad58d683db074e172f29c36d932c66f', 0, 1);
INSERT INTO `sys_file` VALUES (99, '0bc3802f770bfe8516158ec3b1a345f1.jpg', 'jpg', 91, 'http://localhost:9090/file/e82dfdc571e6440ca1b29d44d3b6f142.jpg', '0e26a6dd952a840d0652e7cfb7a777cf', 0, 1);
INSERT INTO `sys_file` VALUES (100, '13f8c824363272db52b8abe619645aa9.jpg', 'jpg', 9, 'http://localhost:9090/file/e69b03234dd14772831bb2d81ed5317c.jpg', '178d00a1b16b0164169d6bfd9986fb70', 0, 1);
INSERT INTO `sys_file` VALUES (101, '14 gettyimages-1176555906_resized.jpg', 'jpg', 660, 'http://localhost:9090/file/41324cc1d9904104bf29e4202fe8b3da.jpg', '241a37e2703bb61deb9047a0e27f29da', 0, 1);
INSERT INTO `sys_file` VALUES (102, '1586611861285.jpg', 'jpg', 37, 'http://localhost:9090/file/ef9ac3f075cd463ca90e4d0dbb56e66a.jpg', '6b0daa8309351583d67f03c85cf1d8c7', 0, 1);
INSERT INTO `sys_file` VALUES (103, '1614074118295.jpg', 'jpg', 19, 'http://localhost:9090/file/07cba459a8904ad39756a31ef1aaaf41.jpg', '26c09240511cfc45544fdbf88a73220e', 0, 1);
INSERT INTO `sys_file` VALUES (104, 'kk.jpg', 'jpg', 366, 'http://localhost:9090/file/6acb9de64e354acbb9aae64c3d0be7c6.jpg', '4e26950519d9253681fa2938a28ce1be', 0, 1);
INSERT INTO `sys_file` VALUES (105, 't0193bce2606532d64f.jpg', 'jpg', 88, 'http://localhost:9090/file/0126797c1e9f456788f7a69e9c053461.jpg', 'ebb679ebe5e222cf373dae19d32ca344', 0, 1);
INSERT INTO `sys_file` VALUES (106, 'OIP.jpg', 'jpg', 11, 'http://localhost:9090/file/924bfa6fea58430ca23a2e70db8d3b09.jpg', 'f5f4ef660a179c1eedc929ed2199dedb', 0, 1);
INSERT INTO `sys_file` VALUES (107, '微信图片_20260113095608_541_84.jpg', 'jpg', 79, 'http://localhost:9090/file/667e038b7928414dbc5fb75fd6e45192.jpg', '69e862d83882a749667ade609a0f7ac7', 0, 1);
INSERT INTO `sys_file` VALUES (108, '微信图片_20260113095635_547_84.jpg', 'jpg', 64, 'http://localhost:9090/file/02c19eb9d56645fb8af816e59c2e4eb1.jpg', 'da5a43b2d209879266438d999b7c414d', 0, 1);
INSERT INTO `sys_file` VALUES (109, '微信图片_20260113095611_543_84.jpg', 'jpg', 155, 'http://localhost:9090/file/017fbc895eed4dae81389365579333bd.jpg', '5771b0af7ed72c8fa7e551bba13dd039', 0, 1);
INSERT INTO `sys_file` VALUES (110, '微信图片_20260113095614_545_84.jpg', 'jpg', 77, 'http://localhost:9090/file/8a052def78c44f0fbbf58c49ce6dda64.jpg', '6d2c657e6e3a0cae76db8ba49a2562b7', 0, 1);
INSERT INTO `sys_file` VALUES (111, '微信图片_20260113095607_540_84.jpg', 'jpg', 92, 'http://localhost:9090/file/d0235e2c0cd84b9aa8184b8651832ac7.jpg', '6405581253ea046522209e79dd9c2a48', 0, 1);
INSERT INTO `sys_file` VALUES (112, '微信图片_20260113095611_543_84.jpg', 'jpg', 155, 'http://localhost:9090/file/017fbc895eed4dae81389365579333bd.jpg', '5771b0af7ed72c8fa7e551bba13dd039', 0, 1);
INSERT INTO `sys_file` VALUES (113, '微信图片_20260113095615_546_84.jpg', 'jpg', 244, 'http://localhost:9090/file/7e9938492ebc407491895350b8d86736.jpg', '7d45f21051d4d45fea7957f3b1d7b128', 0, 1);
INSERT INTO `sys_file` VALUES (114, '微信图片_20260113095612_544_84.jpg', 'jpg', 417, 'http://localhost:9090/file/eac1c993c01a4dff8675461dad69bb2b.jpg', 'c30c6e14ecc17949ccc77b4da74345f9', 0, 1);
INSERT INTO `sys_file` VALUES (115, '科普文章.jpg', 'jpg', 214, 'http://localhost:9090/file/3a70700447594f84ba0f86391f85e278.jpg', '0fc774fac0e9c917e7184a52359eee65', 0, 1);
INSERT INTO `sys_file` VALUES (116, '微信图片_20260114105414_582_84.jpg', 'jpg', 132, 'http://localhost:9090/file/76f0540a06054bb8b464065d0d7081b1.jpg', 'a954ef816ab988760bb38085a18197d6', 0, 1);
INSERT INTO `sys_file` VALUES (117, '微信图片_20260113095615_546_84.jpg', 'jpg', 244, 'http://localhost:9090/file/7e9938492ebc407491895350b8d86736.jpg', '7d45f21051d4d45fea7957f3b1d7b128', 0, 1);
INSERT INTO `sys_file` VALUES (118, '科普文章.jpg', 'jpg', 214, 'http://localhost:9090/file/3a70700447594f84ba0f86391f85e278.jpg', '0fc774fac0e9c917e7184a52359eee65', 0, 1);
INSERT INTO `sys_file` VALUES (119, '微信图片_20260113095615_546_84.jpg', 'jpg', 244, 'http://localhost:9090/file/7e9938492ebc407491895350b8d86736.jpg', '7d45f21051d4d45fea7957f3b1d7b128', 0, 1);
INSERT INTO `sys_file` VALUES (120, 'dog2.jpg', 'jpg', 124, 'http://localhost:9090/file/1e94b9f39d60419086bae95ac19304b4.jpg', 'ba92c835b77bb6c0a6755007d9d0eda7', 0, 1);
INSERT INTO `sys_file` VALUES (121, 'dog.jpg', 'jpg', 17, 'http://localhost:9090/file/5d2a62bb59fd4c77bf43c62fbc348853.jpg', '9601ec04a3ddd65afdbd841dae0ac524', 0, 1);
INSERT INTO `sys_file` VALUES (122, 'e70adeadc6f3a555dbb518b109d6f9c8.png', 'png', 18, 'http://localhost:9090/file/d862f09da76c4ba489927edcb417fa52.png', '8a2e2aca3ac5f8d82da8a9ac44637a57', 0, 1);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路径',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `pid` int NULL DEFAULT NULL COMMENT '父级id',
  `page_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '页面路径',
  `sort_num` int NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (4, '系统管理', NULL, 'el-icon-s-grid', NULL, NULL, NULL, 300);
INSERT INTO `sys_menu` VALUES (5, '用户管理', '/user', 'el-icon-user', NULL, 4, 'User', 301);
INSERT INTO `sys_menu` VALUES (6, '角色管理', '/role', 'el-icon-s-custom', NULL, 4, 'Role', 302);
INSERT INTO `sys_menu` VALUES (7, '菜单管理', '/menu', 'el-icon-menu', NULL, 4, 'Menu', 303);
INSERT INTO `sys_menu` VALUES (8, '文件管理', '/file', 'el-icon-document', NULL, 4, 'File', 304);
INSERT INTO `sys_menu` VALUES (10, '主页', '/home', 'el-icon-house', NULL, NULL, 'Home', 0);
INSERT INTO `sys_menu` VALUES (11, '流浪动物管理', '/animal', 'el-icon-menu', NULL, NULL, 'Animal', 100);
INSERT INTO `sys_menu` VALUES (12, '待绝育动物管理', '/sterilization', 'el-icon-menu', NULL, NULL, 'Sterilization', 999);
INSERT INTO `sys_menu` VALUES (13, '申请领养管理', '/applcation', 'el-icon-guide', NULL, NULL, 'Applcation', 200);
INSERT INTO `sys_menu` VALUES (14, '评论管理', '/comment', 'el-icon-menu', NULL, NULL, 'Comment', 999);
INSERT INTO `sys_menu` VALUES (15, '流浪动物救助', '/salvation', 'el-icon-menu', NULL, NULL, 'Salvation', 999);
INSERT INTO `sys_menu` VALUES (16, '喂养点管理', '/feed', 'el-icon-menu', NULL, NULL, 'Feed', 999);
INSERT INTO `sys_menu` VALUES (18, '动物走失管理', '/lost', 'el-icon-menu', NULL, NULL, 'Lost', 999);
INSERT INTO `sys_menu` VALUES (19, '救助站管理', '/rescue', 'el-icon-menu', NULL, NULL, 'Rescue', 999);
INSERT INTO `sys_menu` VALUES (20, '帖子管理', '/article', 'el-icon-menu', NULL, NULL, 'Article', 999);
INSERT INTO `sys_menu` VALUES (21, '捐赠管理', '/donate', 'el-icon-menu', NULL, NULL, 'Donate', 999);
INSERT INTO `sys_menu` VALUES (23, '科普文章管理', '/articleKp', 'el-icon-menu', NULL, NULL, 'ArticleKp', 999);
INSERT INTO `sys_menu` VALUES (24, '活动管理', '/activity', 'el-icon-menu', NULL, NULL, 'Activity', 999);
INSERT INTO `sys_menu` VALUES (25, '宠物商城管理', '/petProduct', 'el-icon-shopping-cart-full', '宠物商城管理', NULL, 'PetProduct', 201);
INSERT INTO `sys_menu` VALUES (26, '订单管理', '/petOrder', 'el-icon-s-order', '宠物商城订单管理', NULL, 'PetOrder', 202);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `flag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '管理员', '管理员', 'ROLE_ADMIN');
INSERT INTO `sys_role` VALUES (2, '普通用户', '普通用户', 'ROLE_USER');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` int NOT NULL COMMENT '角色id',
  `menu_id` int NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE,
  INDEX `fk_role_menu_menu`(`menu_id` ASC) USING BTREE,
  CONSTRAINT `fk_role_menu_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_role_menu_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色菜单关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 4);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (1, 5);
INSERT INTO `sys_role_menu` VALUES (1, 6);
INSERT INTO `sys_role_menu` VALUES (1, 7);
INSERT INTO `sys_role_menu` VALUES (1, 8);
INSERT INTO `sys_role_menu` VALUES (2, 8);
INSERT INTO `sys_role_menu` VALUES (1, 10);
INSERT INTO `sys_role_menu` VALUES (2, 10);
INSERT INTO `sys_role_menu` VALUES (1, 11);
INSERT INTO `sys_role_menu` VALUES (1, 12);
INSERT INTO `sys_role_menu` VALUES (1, 13);
INSERT INTO `sys_role_menu` VALUES (1, 14);
INSERT INTO `sys_role_menu` VALUES (1, 15);
INSERT INTO `sys_role_menu` VALUES (1, 16);
INSERT INTO `sys_role_menu` VALUES (1, 18);
INSERT INTO `sys_role_menu` VALUES (1, 19);
INSERT INTO `sys_role_menu` VALUES (1, 20);
INSERT INTO `sys_role_menu` VALUES (1, 21);
INSERT INTO `sys_role_menu` VALUES (1, 23);
INSERT INTO `sys_role_menu` VALUES (1, 24);
INSERT INTO `sys_role_menu` VALUES (1, 25);
INSERT INTO `sys_role_menu` VALUES (1, 26);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  `sex` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `birth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出生年月',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', 'admin', '管理员', 'admin@qq.com', '13988997788', '安徽合肥', '2022-01-22 21:10:27', 'http://localhost:9090/file/a561823791374c6e9b403bfc3f3611db.png', 'ROLE_ADMIN', 'male', '1995-06-06');
INSERT INTO `sys_user` VALUES (2, 'zhang', '123', '张张', 'zhang@qq.com', '13677889900', '南京', '2022-02-26 22:10:14', NULL, 'ROLE_USER', 'female', '1995-06-06');
INSERT INTO `sys_user` VALUES (6, 'Test', '123456', 'Test', '123@qq.com', '12345678911', 'dajie', '2025-04-26 11:25:37', NULL, 'ROLE_USER', 'female', '1998-07-06');
INSERT INTO `sys_user` VALUES (7, 'atest', '1234567', 'Kaze', NULL, NULL, NULL, '2026-01-13 09:31:30', 'http://localhost:9090/file/d862f09da76c4ba489927edcb417fa52.png', 'ROLE_USER', 'female', '2003-01-15');
INSERT INTO `sys_user` VALUES (8, 'btest', '1234567', 'btest', NULL, NULL, NULL, '2026-01-15 10:07:07', NULL, 'ROLE_USER', NULL, NULL);

-- ----------------------------
-- Table structure for user_search_log
-- ----------------------------
DROP TABLE IF EXISTS `user_search_log`;
CREATE TABLE `user_search_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `keyword` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '搜索关键词',
  `search_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '搜索时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_searchlog_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_searchlog_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_search_log
-- ----------------------------
INSERT INTO `user_search_log` VALUES (1, 1, '猫', '2025-08-04 17:17:04');
INSERT INTO `user_search_log` VALUES (2, 1, '啊', '2025-08-06 04:29:41');
INSERT INTO `user_search_log` VALUES (3, 1, '啊', '2025-08-06 04:31:42');
INSERT INTO `user_search_log` VALUES (4, 1, '猫', '2025-08-06 04:31:44');
INSERT INTO `user_search_log` VALUES (5, 1, '猫', '2025-08-06 14:50:56');
INSERT INTO `user_search_log` VALUES (6, 1, '啊', '2025-08-06 14:51:03');
INSERT INTO `user_search_log` VALUES (7, 1, '猫', '2025-08-06 14:57:32');
INSERT INTO `user_search_log` VALUES (8, 1, '狗', '2025-08-06 14:57:40');
INSERT INTO `user_search_log` VALUES (9, 1, '1', '2025-08-06 14:58:25');
INSERT INTO `user_search_log` VALUES (10, 1, '狗', '2025-08-06 15:12:49');
INSERT INTO `user_search_log` VALUES (11, 1, '狗', '2025-08-06 15:54:35');

SET FOREIGN_KEY_CHECKS = 1;
