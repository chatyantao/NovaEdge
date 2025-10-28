@echo off
echo ================================================
echo 🚀 NovaEdge Blog 一键上传脚本
echo ================================================

REM Step 1: 清理旧构建
echo 🧹 清理旧的 public 文件夹...
if exist public rmdir /s /q public

REM Step 2: 构建 Hugo 网站
echo 🏗️ 正在生成静态网站...
hugo --gc --minify

if %errorlevel% neq 0 (
    echo ❌ Hugo 构建失败，请检查错误。
    pause
    exit /b
)

REM Step 3: 提交并推送到 GitHub
echo 📤 准备推送到 GitHub...
git add .
set /p commitmsg=请输入提交说明（例如：更新文章）： 
if "%commitmsg%"=="" set commitmsg=更新网站内容
git commit -m "%commitmsg%"
git push origin main

if %errorlevel% neq 0 (
    echo ❌ Git 推送失败，请检查网络或远程仓库。
    pause
    exit /b
)

echo ✅ 上传完成！Cloudflare Pages 将自动构建新版本。
echo 🌍 访问你的博客看看吧！
pause
