# 发布到 GitHub（建议流程）

## 1) 先检查不该提交的内容

本仓库根目录已包含 `.gitignore`，会忽略：

- `node_modules/`
- `target/`
- `.env.local` 等本地配置

如果你之前已经把这些文件 `git add` 过，需要先从 Git 索引移除（不删本地文件）：

- `git rm -r --cached frontend/node_modules backend/target`

## 2) 初始化并提交

在项目根目录执行：

- `git init`
- `git add .`
- `git commit -m "init"`

## 3) 关联远端并推送

在 GitHub 上新建一个空仓库后（不要勾选生成 README/License），复制仓库地址，然后：

- `git branch -M main`
- `git remote add origin <你的仓库地址>`
- `git push -u origin main`

