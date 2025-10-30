@echo off
title 🚀 Hugo 自动部署脚本

echo =================================
echo 🧹 清理旧文件
echo =================================
if exist public rmdir /s /q public

echo =================================
echo 🛠️ 生成静态文件
echo =================================
hugo --gc --minify

if errorlevel 1 (
    echo ❌ Hugo 构建失败，停止部署。
    pause
    exit /b
)

echo ✅ Hugo 构建完成！

echo =================================
echo 📤 提交到 GitHub
echo =================================

git add .

git commit -m "Auto Deploy %date% %time%"

:: 确保我们在 main 分支
git branch | findstr "main" >nul
if errorlevel 1 git checkout main

:: 强制推送
git pull --rebase
git push -f origin main

if errorlevel 1 (
    echo ❌ 推送失败，请检查 Token、网络 或 GitHub 权限。
    pause
    exit /b
)

echo =================================
echo ✅ 部署完成！
echo 🌍 访问网站: https://novaedge.vip
echo =================================

pause
