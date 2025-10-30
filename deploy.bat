@echo off
chcp 65001 >nul

echo ==========================================
echo 🚀 NovaEdge 一键部署系统 - 火力全开
echo ==========================================

REM -------- Git 用户身份检查 ----------
git config --global user.name >nul 2>&1
if %errorlevel% neq 0 (
    echo 👤 未检测到 Git 用户配置，正在设置...
    git config --global user.name "chatyantao"
    git config --global user.email "chatyantao@gmail.com"
)

echo ✅ Git 用户身份已确认

REM -------- 清理 Hugo 输出 ----------
echo 🧹 清理历史构建文件...
if exist public rmdir /s /q public

REM -------- 保留 Cloudflare CNAME ----------
if exist docs\CNAME (
    echo 🔒 检测到 CNAME，确保 Cloudflare 域名不丢失...
    copy docs\CNAME CNAME >nul
)

REM -------- Hugo 构建 ----------
echo 🛠 运行 Hugo 构建...
hugo -D
if %errorlevel% neq 0 (
    echo ❌ Hugo 构建失败！
    pause
    exit /b
)

echo ✅ Hugo 构建完成

REM -------- CNAME 写回到 docs ----------
if exist CNAME (
    move CNAME docs\CNAME >nul
    echo 🔁 已写回 CNAME，域名安全 ✅
)

REM -------- Git 更新流程 ----------
echo 📦 准备提交代码...

git add .
git commit -m "Auto deploy at %date% %time%" >nul 2>&1

echo 🔍 检查冲突与未提交状态...
git status | find "rebase in progress" >nul
if %errorlevel%==0 (
    echo ⚠ 检测到 rebase 进行中，正在修复...
    git rebase --abort
)

git pull --rebase >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠ 检测到冲突，执行自动 stash...
    git stash
    git pull --rebase
    git stash pop
)

echo 🚢 推送到 GitHub...
git push
if %errorlevel% neq 0 (
    echo ❌ 推送失败！请检查网络 或 GitHub Token
    pause
    exit /b
)

echo ✅ Git 推送成功

REM -------- 打开博客 ----------
set BLOG_URL=https://novaedge.vip
echo 🌍 打开网站：%BLOG_URL%
start %BLOG_URL%

echo ==========================================
echo 🎉 部署完成！博客更新已上线！
echo ==========================================
pause
