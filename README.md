# 🐾 Smart Pet Platform | 智能宠物领养与管理平台

本项目是一个基于 **Spring Boot 3** 与 **Vue 3** 开发的前后端分离宠物领养系统。不同于传统的领养平台，本项目集成了 **AI 大模型能力**，旨在通过智能化手段提升流浪动物的领养匹配率与安全性。

## 🌟 核心亮点

* **🤖 AI 助手实时问答**：集成 DeepSeek 大模型，为用户提供 24/7 的养宠咨询、政策解读及领养引导。
* **⚖️ AI 后台风险评估**：利用 AI 对领养申请人的背景描述、领养动机进行多维度分析，自动生成风险评分与审核建议，辅助管理人员决策。
* **🎯 智能匹配推荐**：基于用户偏好画像，算法自动推荐最契合的宠物，提高领养成功率。
* **📱 全流程闭环管理**：涵盖从宠物入库、领养申请、AI 风险评估到最终审核、回访的完整生命周期。

## 🛠️ 技术栈

### 后端 (Backend)

* **核心框架**：Spring Boot 3.x
* **数据库**：MySQL 8.0 + MyBatis-Plus
* **缓存与中间件**：Redis (数据缓存) + RabbitMQ (异步消息)
* **AI 集成**：Spring AI / HTTP Client (DeepSeek API)

### 前端 (Frontend)

* **框架**：Vue 3 (Composition API)
* ** UI 组件库**：Element Plus
* **状态管理**：Pinia

## 📁 目录结构

```text
├── pet-backend     # 后端 Spring Boot 源码
├── pet-frontend    # 前端 Vue 3 源码
├── sql             # 数据库初始化脚本
└── README.md       # 项目说明文档

```

## 🚀 快速启动

### 1. 数据库准备

* 在 MySQL 中创建数据库 `stray_animal`。
* 依次执行 `sql/` 目录下的 `.sql` 文件以初始化表结构及基础数据。

### 2. 后端配置

* 进入 `pet-backend/src/main/resources/`。
* 将 `application.yml` 中的数据库、Redis、RabbitMQ 密码及 `deepseek.api-key` 配置为你的真实信息（推荐使用环境变量）。

### 3. 前端启动

```bash
cd pet-frontend
npm install
npm run dev

```

## 📝 开发路线 (Roadmap)

* [x] 核心领养流程实现
* [x] DeepSeek AI 助手接入
* [x] AI 风险评估算法建模
* [ ] 领养后的在线回访社区
* [ ] 宠物健康档案电子化
