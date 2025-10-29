@echo off
chcp 65001 >nul
echo =====================================================
echo 🚀 NovaEdge Blog 智能部署脚本（自动检测 GitHub 登录）
echo =====================================================

REM === 检查 Hugo 是否存在 ===
where hugo >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到 Hugo，请确保 hugo.exe 在本目录。
    pause
    exit /b
)

REM === 检查 GitHub 凭据是否存在 ===
echo 🔍 检查 GitHub 凭据...
setlocal enabledelayedexpansion
set TOKEN_PATH=%USERPROFILE%\.git-credentials

if not exist "!TOKEN_PATH!" (
    echo ⚠️ 尚未保存 GitHub 登录信息。
    echo.
    set /p GITHUB_TOKEN=请输入你的 GitHub Personal Access Token（以 ghp_ 开头）并按回车确认： 
    REM 检查是否真的读取到了内容
    if "!GITHUB_TOKEN!"=="" (
        echo ❌ 未输入 Token，已退出。
        pause
        exit /b
    )
    echo https://chatyantao:!GITHUB_TOKEN!@github.com> "!TOKEN_PATH!"
    git config --global credential.helper store
    echo ✅ GitHub Token 已保存，下次会自动使用。
) else (
    echo ✅ 已检测到 GitHub 登录凭据。
)
endlocal

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
git remote set-url origin https://github.com/chatyantao/NovaEdge.git
git push
if %errorlevel% neq 0 (
    echo ❌ 推送失败，请检查 Token 或网络。
    pause
    exit /b
)

echo =====================================================
echo ✅ 部署完成！
echo 🌐 访问地址: https://novaedge.vip
echo 💡 Cloudflare Pages 会自动检测 push 并开始重新构建。
echo =====================================================

start https://novaedge.vip
pause
