# Big-Event 用户使用手册

## 📖 项目简介

**Big-Event（大事件）** 是一个基于前后端分离架构的轻量级博客系统，提供用户管理、文章分类管理和文章管理等核心功能。

本项目是根据 **黑马程序员 SpringBoot3+Vue3 全套视频教程** 学习实践而来，教程地址：
[SpringBoot3+Vue3企业级全栈开发从基础、实战到面试一套通关](https://www.bilibili.com/video/BV14z4y1N7pg?spm_id_from=333.788.videopod.episodes&vd_source=8fe4bb97348fb68a474426608e304a8b)

---

## 🏗️ 技术架构

### 后端技术栈
- **Spring Boot 3.1.3** - 核心框架
- **MyBatis 3.0.0** - 持久层框架
- **MySQL 8.x** - 关系型数据库
- **Redis** - 缓存服务
- **JWT (Java-JWT 4.4.0)** - 身份认证
- **Aliyun OSS** - 文件存储（图片上传）
- **PageHelper** - 分页插件
- **Lombok** - 代码简化

### 前端技术栈
- **Vue 3.3.4** - 前端框架
- **Vite 4.4.11** - 构建工具
- **Element Plus 2.4.1** - UI 组件库
- **Vue Router 4.2.5** - 路由管理
- **Pinia 2.1.7** - 状态管理
- **Axios 1.5.1** - HTTP 请求库
- **Vue Quill** - 富文本编辑器

---

## 📦 项目结构

```
big-event/
├── backend/                 # 后端项目
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/itheima/
│   │   │   │   ├── anno/          # 自定义注解
│   │   │   │   ├── config/        # 配置类
│   │   │   │   ├── controller/    # 控制器层
│   │   │   │   ├── exception/     # 异常处理
│   │   │   │   ├── interceptors/  # 拦截器
│   │   │   │   ├── mapper/        # 数据访问层
│   │   │   │   ├── pojo/          # 实体类
│   │   │   │   ├── service/       # 业务逻辑层
│   │   │   │   ├── utils/         # 工具类
│   │   │   │   └── validation/    # 参数校验
│   │   │   └── resources/
│   │   │       └── application.yml  # 配置文件
│   │   └── test/           # 测试代码
│   └── pom.xml             # Maven 依赖配置
├── frontend/               # 前端项目
│   ├── src/
│   │   ├── api/            # API 接口封装
│   │   ├── assets/         # 静态资源
│   │   ├── components/     # 公共组件
│   │   ├── router/         # 路由配置
│   │   ├── stores/         # Pinia 状态管理
│   │   ├── utils/          # 工具函数
│   │   ├── views/          # 页面组件
│   │   │   ├── article/    # 文章相关页面
│   │   │   └── user/       # 用户相关页面
│   │   ├── App.vue         # 根组件
│   │   └── main.js         # 入口文件
│   ├── vite.config.js      # Vite 配置
│   └── package.json        # 依赖配置
├── db/                     # 数据库脚本
│   └── big_event_init.sql  # 数据库初始化
├── docs/                   # 文档目录
├── dev.cmd                 # Windows 一键启动脚本（CMD）
├── dev.ps1                 # Windows 一键启动脚本（PowerShell）
└── README.md               # 项目说明
```

---

## ⚙️ 环境要求

### 必需软件
- **JDK 17** - 后端运行环境（必须使用 JDK 17）
- **Maven 3.8+** - 后端依赖管理和构建
- **Node.js 16+**（推荐 18+）- 前端运行环境
- **MySQL 8.x** - 数据库（默认库名：`big_event`）
- **Redis** - 缓存服务（默认：`localhost:6379`）

### 推荐开发工具
- **IntelliJ IDEA** - 后端开发
- **VS Code** - 前端开发
- **Navicat / DBeaver** - 数据库管理
- **RedisInsight** - Redis 可视化管理

---

## 🚀 快速开始

### 方式一：Windows 一键启动（推荐）

#### 1. 初始化数据库
使用 MySQL 客户端（Navicat、DBeaver 或命令行）执行初始化脚本：
```sql
source /path/to/db/big_event_init.sql
```

或使用命令行：
```bash
mysql -u root -p < db/big_event_init.sql
```

#### 2. 配置环境变量
在项目根目录创建 `.env.local` 文件（该文件已在 `.gitignore` 中，不会被提交到 Git）：

```env
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_NAME=big_event
DB_USERNAME=root
DB_PASSWORD=你的MySQL密码

# Redis 配置
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# 后端服务端口（可选，默认 8081）
SERVER_PORT=8081

# JDK 17 路径（可选，如果不配置会自动查找）
# JAVA17_HOME=C:\Program Files\Java\jdk-17
```

#### 3. 安装前端依赖
```bash
cd frontend
npm install
```

#### 4. 一键启动
双击运行 `dev.cmd`（CMD）或在 PowerShell 中运行：
```bash
powershell -ExecutionPolicy Bypass -File .\dev.ps1
```

启动后访问：
- **前端地址**：http://localhost:5173/
- **后端地址**：http://localhost:8081/

**默认测试账号**：
- 用户名：`admin` / 密码：`123456`

---

### 方式二：手动启动

#### 后端启动
```bash
# 进入后端目录
cd backend

# 配置环境变量（或在 application.yml 中修改）
export DB_PASSWORD=你的密码
export REDIS_PASSWORD=你的密码（如有）

# 使用 Maven 启动（需要配置 JAVA_HOME）
mvn spring-boot:run

# 或指定 JDK 17 启动
set JAVA_HOME=C:\Path\To\JDK17
mvn spring-boot:run
```

#### 前端启动
```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

---

## 📋 功能说明

### 1. 用户模块

#### 1.1 用户注册
- 用户名唯一性校验
- 密码 MD5 加密存储
- 必填项验证

#### 1.2 用户登录
- JWT Token 认证
- 登录态持久化（Pinia + localStorage）
- 自动登录功能

#### 1.3 个人信息管理
- 查看个人信息
- 修改昵称、邮箱
- 头像上传（阿里云 OSS）
- 密码重置

### 2. 文章分类模块

#### 2.1 分类管理
- 创建文章分类
- 查看分类列表
- 更新分类信息
- 删除分类

#### 2.2 分类特性
- 每个用户只能管理自己的分类
- 分类名称和别名唯一性校验

### 3. 文章管理模块

#### 3.1 文章发布
- 富文本编辑器（Vue Quill）
- 文章标题、内容编辑
- 封面图片上传
- 选择文章分类

#### 3.2 文章状态
- **草稿**：暂存未发布
- **已发布**：正式发布状态

#### 3.3 文章操作
- 查看文章列表（分页）
- 编辑文章
- 删除文章
- 按分类筛选

---

## 🔧 配置说明

### 后端配置（application.yml）

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://${DB_HOST:localhost}:${DB_PORT:3306}/${DB_NAME:big_event}
    username: ${DB_USERNAME:root}
    password: ${DB_PASSWORD:}
  data:
    redis:
      host: ${REDIS_HOST:localhost}
      port: ${REDIS_PORT:6379}
      password: ${REDIS_PASSWORD:}

mybatis:
  configuration:
    map-underscore-to-camel-case: true  # 驼峰命名转换
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl  # SQL 日志

server:
  port: ${SERVER_PORT:8081}
```

### 前端配置（vite.config.js）

```javascript
export default defineConfig(({ mode }) => {
  const serverPort = process.env.SERVER_PORT || env.SERVER_PORT || 8081
  const backendTarget = `http://localhost:${serverPort}`

  return {
    server: {
      proxy: {
        '/api': {
          target: backendTarget,
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },
  }
})
```

---

## 🎯 API 接口说明

### 认证相关
- `POST /register` - 用户注册
- `POST /login` - 用户登录
- `GET /userInfo` - 获取当前用户信息
- `PUT /userInfo` - 更新用户信息
- `PATCH /updatePwd` - 修改密码
- `POST /upload` - 上传文件（头像、封面图）

### 文章分类相关
- `POST /category` - 创建分类
- `GET /category` - 获取分类列表
- `PUT /category` - 更新分类
- `DELETE /category` - 删除分类

### 文章管理相关
- `POST /article` - 发布文章
- `GET /article` - 获取文章列表（分页）
- `GET /article/detail` - 获取文章详情
- `PUT /article` - 更新文章
- `DELETE /article` - 删除文章

---

## 🐛 常见问题

### 1. 前端报错：`http proxy error ... ECONNREFUSED`
**原因**：后端未启动或端口配置错误

**解决方法**：
- 确认后端已成功启动
- 检查后端端口是否正确（默认 8081）
- 检查 `.env.local` 中的 `SERVER_PORT` 配置

### 2. 后端编译报错：`JCTree...qualid`
**原因**：JDK 版本过高（如 JDK 22）

**解决方法**：
- 必须使用 **JDK 17**
- 配置环境变量 `JAVA17_HOME` 指向 JDK 17 路径
- 或在 `dev.cmd` 中手动设置 `JAVA_HOME`

### 3. 数据库连接失败
**原因**：MySQL 配置错误或服务未启动

**解决方法**：
- 确认 MySQL 服务已启动
- 检查 `.env.local` 中的数据库配置
- 确认数据库名为 `big_event` 已创建

### 4. Redis 连接失败
**原因**：Redis 未启动或密码配置错误

**解决方法**：
- 启动 Redis 服务（项目根目录 `redis/` 下有 Windows 版 Redis）
- 检查 `.env.local` 中的 Redis 配置
- 如有密码，设置 `REDIS_PASSWORD`

### 5. 端口被占用
**原因**：8081 或 5173 端口已被其他程序占用

**解决方法**：
- `dev.cmd` 脚本会自动查找空闲端口（8081-8090）
- 手动指定端口：在 `.env.local` 中设置 `SERVER_PORT=其他端口`

### 6. 文件上传失败
**原因**：阿里云 OSS 未配置或权限问题

**解决方法**：
- 检查后端 `AliOssUtil.java` 中的 OSS 配置
- 确认 Bucket 已创建且有读写权限

---

## 📦 构建与部署

### 后端打包
```bash
cd backend
mvn clean package -DskipTests
# 生成的 JAR 文件在 target/ 目录下
java -jar target/big-event-1.0-SNAPSHOT.jar
```

### 前端打包
```bash
cd frontend
npm run build
# 生成的静态文件在 dist/ 目录下
```

### 生产环境部署
1. 将前端 `dist/` 目录部署到 Nginx
2. 配置 Nginx 反向代理到后端 API
3. 启动后端 JAR 包
4. 配置生产环境的环境变量

---

## 📝 学习资源

### 官方文档
- [Spring Boot 官方文档](https://spring.io/projects/spring-boot)
- [Vue 3 官方文档](https://cn.vuejs.org/)
- [Vite 官方文档](https://cn.vitejs.dev/)
- [Element Plus 官方文档](https://element-plus.org/zh-CN/)
- [MyBatis 官方文档](https://mybatis.org/mybatis-3/zh/)

### 视频教程
本项目基于 **黑马程序员** 的视频教程学习实践：
- **教程名称**：SpringBoot3+Vue3企业级全栈开发从基础、实战到面试一套通关
- **Bilibili 地址**：https://www.bilibili.com/video/BV14z4y1N7pg?spm_id_from=333.788.videopod.episodes&vd_source=8fe4bb97348fb68a474426608e304a8b

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 代码规范
- 后端遵循 Java 代码规范
- 前端遵循 Vue 风格指南
- 提交前进行代码格式化

---

## 📄 开源协议

本项目仅供学习交流使用。

---

## 👨‍💻 作者信息

- **项目来源**：黑马程序员 SpringBoot3+Vue3 全套视频教程学习实践
- **开发时间**：2026年

---

## 📮 联系方式

如有问题或建议，欢迎提交 Issue。

---

**祝你使用愉快！** 🎉
