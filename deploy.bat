@echo off
chcp 65001 >nul

echo 🚀 NovaEdge Hugo Auto Deploy
echo -------------------------------------

REM 1) 清理旧构建
echo 🧹 Cleaning old docs...
if exist docs (
    rd /s /q docs
)

REM 2) 构建 Hugo 输出
echo 🏗️ Building site with Hugo...
hugo -D

if %errorlevel% neq 0 (
    echo ❌ Hugo build failed, exit.
    pause
    exit /b 1
)

REM 3) Git workflow
echo 🔄 Staging Git changes...
git add .

echo 🧾 Committing...
git commit -m "deploy: auto build on %date% %time%" 2>nul

REM 4) 保证没有rebase冲突
git rebase --abort 2>nul

REM 5) 拉取远程更新避免冲突
echo ⬇️ Pulling latest changes...
git pull --rebase

echo 🚢 Pushing to GitHub...
git push

echo ✅ Done! Website Updated!
echo 🌐 Visit: https://novaedge.vip/
echo -------------------------------------
pause
