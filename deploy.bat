@echo off
chcp 65001 >nul

title NovaEdge Deploy

echo ========== NovaEdge Auto Deploy ==========

cd /d %~dp0

:: Ensure git identity
for /f "delims=" %%i in ('git config user.name') do set GITNAME=%%i
for /f "delims=" %%i in ('git config user.email') do set GITEMAIL=%%i

if "%GITNAME%"=="" git config --global user.name "chatyantao"
if "%GITEMAIL%"=="" git config --global user.email "chatyantao@gmail.com"

echo [OK] Git user configured

echo.
echo [STEP] Pull latest changes...
git pull --rebase
if %errorlevel% neq 0 (
    echo [WARN] Rebase conflict, aborting...
    git rebase --abort >nul 2>&1
)

:: Backup docs
if exist docs (
    echo [STEP] Backup old docs...
    rmdir /s /q docs_backup 2>nul
    ren docs docs_backup
)

:: Clean old public
rmdir /s /q public 2>nul

echo.
echo [STEP] Build Hugo...
hugo -D
if %errorlevel% neq 0 (
    echo [FAIL] Hugo build failed
    pause
    exit /b
)

echo [OK] Build complete

echo.
echo [STEP] Prepare deploy folder...
ren public docs

:: Git operations
echo [STEP] Commit and push...
git add .
git commit -m "deploy: %date% %time%" >nul 2>&1

git push
if %errorlevel% neq 0 (
    echo [WARN] Push failed, retrying after rebase...
    git pull --rebase
    git push
)

echo.
echo ========== DEPLOY SUCCESS ==========
echo Website: https://novaedge.vip/
echo ====================================
pause
