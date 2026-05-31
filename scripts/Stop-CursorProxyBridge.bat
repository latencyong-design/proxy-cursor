@echo off
schtasks /End /TN "CursorProxyBridge" >nul 2>nul
taskkill /IM ProxyBridge_CLI.exe /F >nul 2>nul
exit /b 0
