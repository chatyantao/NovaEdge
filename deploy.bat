@echo off
title 🚀 NovaEdge Auto Deploy

echo -------------------------------------
echo 🚀 NovaEdge 博客自动部署启动
echo -------------------------------------

:: 强制切到脚本目录
cd /d %~dp0

:: 检查 Git 配置（避免 Unknown author）
for /f "delims=" %%i in ('git config user.name') do set GITNAME=%%i
for /f "delims=" %%i in ('git config user.email') do set GITEMAIL=%%i

if "%GITNAME%"=="" (
    echo ⚠️ 检测到未配置 git 用户名，正在自动设置...
    git config --global user.name "chatyantao"
)
if "%GITEMAIL%"=="" (
    echo ⚠️ 检测到未配置 git 邮箱，正在自动设置...
    git config --global user.email "chatyantao@gmail.com"
)

echo ✅ Git 用户信息已确认

echo.
echo 🔄 检查远程更新...
git pull --rebase
if %errorlevel% neq 0 (
    echo ⚠️ 远程更新冲突，执行恢复...
    git rebase --abort >nul 2>&1
    echo ✅ 已恢复 rebase
)

:: 备份 docs 防止人祸
if exist docs (
    echo 📦 备份 docs
    rmdir /s /q docs_backup 2>nul
    ren docs docs_backup
)

echo.
echo 🧹 清理旧 build
rmdir /s /q public 2>nul

echo.
echo 🏗️ 使用 Hugo 生成静态网站...
hugo -D

if %errorlevel% neq 0 (
    echo ❌ Hugo 构建失败
    pause
    exit /b
)

echo.
echo 📁 将 public 重命名为 docs
ren public docs

echo.
echo 📝 git 提交更新...
git add .
git commit -m "auto: deploy at %date% %time%" >nul 2>&1

echo 🚚 推送到 GitHub...
git push

if %errorlevel% neq 0 (
    echo ❌ 推送失败！执行最终补救...
    git pull --rebase
    git push
)

echo -------------------------------------
echo ✅ ✅ ✅  部署成功！访问: https://novaedge.vip/
echo -------------------------------------
pause
