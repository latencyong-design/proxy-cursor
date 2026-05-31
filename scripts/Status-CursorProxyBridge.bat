@echo off
echo Scheduled task:
schtasks /Query /TN "CursorProxyBridge" /FO LIST 2>nul
echo.
echo Process:
tasklist /FI "IMAGENAME eq ProxyBridge_CLI.exe"
pause
