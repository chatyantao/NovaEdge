@echo off
chcp 65001 >nul

echo =================================
echo 🚀 Hugo Deploy Script (UTF-8)
echo =================================

REM Build site
hugo -D --destination docs
if %errorlevel% neq 0 (
    echo ❌ Hugo build failed!
    pause
    exit /b
)

REM Check proxy
echo 🌐 Checking proxy state...
setlocal
for /f "tokens=2 delims=:" %%A in ('netstat -ano ^| find ":7890"') do (
    set PROXYON=true
)

if defined PROXYON (
    echo ✅ Proxy detected, applying Git proxy...
    git config --global http.proxy http://127.0.0.1:7890 >nul
    git config --global https.proxy http://127.0.0.1:7890 >nul
) else (
    echo ⚠ No proxy detected, pushing directly...
)

REM Add & commit
echo 📦 Staging changes...
git add .
git commit -m "update blog" >nul

REM Push
echo 🚢 Pushing to GitHub...
git push
if %errorlevel% neq 0 (
    echo ❌ Push failed!
    echo 💡 Please check your network or GitHub token.
    pause
    exit /b
)

REM Clear Git proxy
if defined PROXYON (
    echo 🧹 Clearing Git proxy...
    git config --global --unset http.proxy >nul
    git config --global --unset https.proxy >nul
)

echo ✅ Deployment complete!

REM Open site (change URL to your GitHub Pages)
set BLOG_URL=https://novaedge.vip

echo 🌍 Opening: %BLOG_URL%
start %BLOG_URL%

echo =================================
echo 🎉 All done! Enjoy blogging.
echo =================================
pause
