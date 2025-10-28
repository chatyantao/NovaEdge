@echo off
chcp 65001 >nul
title 🚀 NovaEdge 一键部署脚本

echo =========================================
echo 🚀 NovaEdge Blog 一键部署开始...
echo =========================================
echo.

REM 第1步：清理旧构建
echo 🧹 清理旧构建文件...
if exist public rmdir /s /q public

REM 第2步：生成静态文件
echo 🏗️ 生成 Hugo 静态文件中...
hugo --gc --minify
if errorlevel 1 (
    echo ❌ Hugo 构建失败！
    pause
    exit /b
)

REM 第3步：准备提交到 GitHub
echo.
echo 🧩 准备提交到 GitHub 仓库...
git add -A

REM 自动生成提交信息（附时间）
set commitMsg=Auto Deploy: %date% %time%
git commit -m "%commitMsg%"
if errorlevel 1 (
    echo ⚠️ 没有可提交的更改，继续下一步...
)

REM 第4步：推送到远程仓库
echo.
echo ⏫ 推送到 GitHub...
git push origin main
if errorlevel 1 (
    echo ❌ 推送失败，请检查网络或 Git 认证。
    pause
    exit /b
)

REM 第5步：打开 Cloudflare 页面
echo.
echo 🌐 部署完成！正在打开网站...
start https://novaedge.vip/

echo.
echo ✅ 所有步骤完成！
pause
