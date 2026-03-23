# big-event（前后端分离）

一个 Spring Boot + MyBatis 的后端服务，配套 Vue3 + Vite 的前端页面，包含用户、文章分类、文章管理等基础功能。

## 目录结构

- `backend/`：后端（Spring Boot / Maven）
- `frontend/`：前端（Vue3 / Vite）
- `db/`：数据库初始化脚本
- `dev.cmd` / `dev.ps1`：Windows 一键启动前后端脚本

## 环境要求

- JDK 17（本项目后端建议使用 JDK 17 运行/编译）
- Maven 3.8+
- Node.js 16+（建议 18+）+ npm
- MySQL 8.x（库名默认 `big_event`）
- Redis（默认 `localhost:6379`）

## 快速开始（Windows）

1) 初始化数据库

- 执行 `db/big_event_init.sql`

2) 配置本地环境变量（推荐用 `.env.local`）

- 复制 `.env.local.example` 为 `.env.local`，填上你的配置（该文件已在 `.gitignore` 中忽略，不会提交到 GitHub）

3) 安装前端依赖

- `cd frontend && npm i`

4) 一键启动

- 双击运行 `dev.cmd`（或 `powershell -ExecutionPolicy Bypass -File .\\dev.ps1`）

访问：

- 前端：`http://localhost:5173/`
- 后端：`http://localhost:8081/`（默认；如果端口被占用，脚本会自动递增尝试）

## 常见问题

- 前端出现 `http proxy error ... ECONNREFUSED`：一般是后端没启动成功或端口不对；确认后端端口在监听（默认 `8081`）。
- 后端编译报 `JCTree...qualid`：通常是 JDK 版本过高导致（例如 JDK 22）；请使用 JDK 17。

## 发布到 GitHub

见 `docs/发布到GitHub.md`。
