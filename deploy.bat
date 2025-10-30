@echo off
chcp 65001 >nul

echo =====================================
echo 🚀 NovaEdge Blog Deploy System
echo =====================================

:: 检查 Hugo
echo ⏳ Checking Hugo...
where hugo >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Hugo 未安装！请把 hugo.exe 放到当前目录或加入 PATH
    pause
    exit /b
)

:: 检查 Git
echo ⏳ Checking Git...
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Git 未安装！
    pause
    exit /b
)

:: 检查 public 是否需要清理
if exist public (
    echo 🧹 Cleaning old build...
    rmdir /S /Q public
)

:: 保证 CNAME 不被删
if exist docs\CNAME (
    echo 🔒 CNAME 已存在，保持 Cloudflare 域名
)

:: Hugo 构建
echo ⚙️  Building site with Hugo...
hugo -D
if %ERRORLEVEL% neq 0 (
    echo ❌ Hugo build 失败！
    pause
    exit /b
)

:: Git 状态检查
echo 📦 Checking git status...
git status --porcelain >temp_git_status.txt
findstr /R /C:"." temp_git_status.txt >nul
if %ERRORLEVEL% neq 0 (
    echo ✅ 工作区干净，无需提交
) else (
    echo 📝 Committing changes...
    git add .
    git commit -m "Auto deploy at %DATE% %TIME%"
)
del temp_git_status.txt

:: 自动避免 rebase 冲突
git pull --rebase
if %ERRORLEVEL% neq 0 (
    echo ⚠️  Git rebase 出现冲突，请手动解决！
    pause
    exit /b
)

:: 自动检测代理端口
echo 🌐 Checking proxy...
set PROXY=""
for %%P in (7890 1080 8080) do (
    netstat -ano | findstr "%%P" >nul && set PROXY=%%P
)

if defined PROXY (
    echo ✅ 代理检测到端口 %PROXY%，启用 Git Proxy
    git config --global http.proxy http://127.0.0.1:%PROXY%
    git config --global https.proxy http://127.0.0.1:%PROXY%
) else (
    echo ⚠ 无代理，直连模式
)

:: 优先走 SSH（更快，不被 reset）
echo 🔐 Switching Git remote to SSH...
git remote set-url origin git@github.com:chatyantao/NovaEdge.git

:: 推送
echo 🚀 Pushing to GitHub...
git push
if %ERRORLEVEL% neq 0 (
    echo ❌ push 失败！
    pause
    exit /b
)

:: 清理代理
if defined PROXY (
    echo 🧹 Clearing Git proxy...
    git config --global --unset http.proxy
    git config --global --unset https.proxy
)

echo 🌍 部署完成，打开网站...
start https://novaedge.vip/

echo =====================================
echo ✅ Done！你的博客已全球发布
echo =====================================
pause
