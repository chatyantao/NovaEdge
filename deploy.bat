@echo off
:: 🚀 NovaEdge 一键发布脚本

:: Step 1. 进入博客目录（如果脚本放在根目录，可省略）
cd /d "%~dp0"

echo.
echo 🧹 清理旧文件...
if exist public (
    rd /s /q public
)
echo ✅ 清理完成

echo.
echo 🏗️ 构建 Hugo 静态文件...
hugo --gc --minify
if %errorlevel% neq 0 (
    echo ❌ Hugo 构建失败！
    pause
    exit /b
)
echo ✅ 构建完成

echo.
echo 📦 提交到 GitHub 仓库...
git add .
set /p msg=请输入提交说明（默认：自动更新）:
if "%msg%"=="" set msg=自动更新
git commit -m "%msg%"
git push origin main

if %errorlevel% neq 0 (
    echo ❌ 提交失败，请检查网络或 Git 设置。
    pause
    exit /b
)
echo ✅ 提交成功，已推送到 GitHub

echo.
echo 🌐 等待 Cloudflare Pages 自动构建中...
echo 💡 请稍后访问: https://novaedge.vip/

pause
exit
