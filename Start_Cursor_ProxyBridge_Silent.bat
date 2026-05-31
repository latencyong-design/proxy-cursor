@echo off
set "SCRIPT_DIR=%~dp0scripts"

if not exist "%SCRIPT_DIR%\Start-CursorProxyBridge.ps1" (
  echo Launcher script not found: %SCRIPT_DIR%\Start-CursorProxyBridge.ps1
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%\Start-CursorProxyBridge.ps1"
if errorlevel 1 pause
exit /b %ERRORLEVEL%
