@echo off
title 🧩 NovaEdge 本地预览助手 v2.0
chcp 65001 >nul
setlocal enabledelayedexpansion

echo =========================================
echo 🧭 检查环境...
echo =========================================

cd /d "%~dp0"

if not exist hugo.exe (
    echo ❌ 未找到 hugo.exe，请确认它与本脚本在同一目录。
    pause
    exit /b
)
echo ✅ 检测到 hugo.exe。
echo.

echo =========================================
echo 🚀 启动 Hugo 本地预览服务...
echo =========================================
start "" http://localhost:1313
hugo server --buildDrafts --buildFuture --disableFastRender --ignoreCache

pause
