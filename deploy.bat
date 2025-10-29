@echo off
chcp 65001 >nul
echo =====================================================
echo 🚀 NovaEdge Blog 一键部署脚本
echo =====================================================

REM === 清理旧缓存 ===
echo 🧹 正在清除 Hugo 缓存...
hugo mod clean
if exist resources rd /s /q resources
if exist public rd /s /q public
echo ✅ 缓存清理完成。

REM === 重新构建网站 ===
echo 🏗️ 开始构建 Hugo 静态文件...
hugo --gc --minify --baseURL "https://novaedge.vip/"
if %errorlevel% neq 0 (
    echo ❌ 构建失败，请检查 hugo.toml 或内容文件！
    pause
    exit /b
)
echo ✅ 构建完成，已生成 public 文件夹。

REM === 推送到 GitHub ===
echo 🧩 准备提交到 GitHub 仓库...
git add .
git commit -m "Auto Deploy: %date% %time%" >nul 2>&1

echo ⏫ 正在推送到 GitHub...
git push
if %errorlevel% neq 0 (
    echo ❌ 推送失败，请检查网络或 Git 认证。
    pause
    exit /b
)

echo =====================================================
echo ✅ 部署完成！
echo 🌐 访问地址: https://novaedge.vip
echo 💡 Cloudflare Pages 会自动检测 push 并开始重新构建。
echo =====================================================

pause
