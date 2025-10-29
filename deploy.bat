@echo off
chcp 65001 >nul
echo =====================================================
echo 🚀 NovaEdge Blog 一键部署脚本
echo =====================================================

REM === 检查 Git 远程地址 ===
for /f "tokens=* usebackq" %%A in (`git remote get-url origin`) do set GITURL=%%A
echo 当前 Git 远程仓库：%GITURL%

echo.
echo 🧹 清理 Hugo 缓存...
hugo mod clean
if exist resources rd /s /q resources
if exist public rd /s /q public
echo ✅ 缓存清理完成。

echo.
echo 🏗️ 开始构建 Hugo...
hugo --gc --minify --baseURL "https://novaedge.vip/"
if %errorlevel% neq 0 (
    echo ❌ 构建失败，请检查 hugo.toml 或内容文件。
    pause
    exit /b
)
echo ✅ 构建完成，已生成 public 文件夹。

echo.
echo 🧩 准备提交到 GitHub...
git add .
git commit -m "Auto Deploy: %date% %time%" >nul 2>&1

echo.
echo ⏫ 推送到 GitHub...
git push
if %errorlevel% neq 0 (
    echo ❌ 推送失败，尝试切换为 HTTPS 认证方式...
    git remote set-url origin https://github.com/chatyantao/NovaEdge.git
    git push
    if %errorlevel% neq 0 (
        echo 🚫 推送仍然失败，请检查网络或 GitHub Token。
        pause
        exit /b
    )
)

echo =====================================================
echo ✅ 部署完成！
echo 🌐 访问地址: https://novaedge.vip
echo 💡 Cloudflare Pages 会自动检测 push 并开始重新构建。
echo =====================================================

pause
