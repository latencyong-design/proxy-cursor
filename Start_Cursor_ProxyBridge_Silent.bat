@echo off
set "TASK=CursorProxyBridge"
set "CURSOR=%LOCALAPPDATA%\Programs\cursor\Cursor.exe"
set "SCRIPT_DIR=%~dp0scripts"

if not exist "%CURSOR%" (
  echo Cursor not found: %CURSOR%
  pause
  exit /b 1
)

if not exist "%SCRIPT_DIR%\Install-CursorProxyBridgeTask.ps1" (
  echo Installer script not found: %SCRIPT_DIR%\Install-CursorProxyBridgeTask.ps1
  pause
  exit /b 1
)

schtasks /Query /TN "%TASK%" >nul 2>nul
if errorlevel 1 (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','%SCRIPT_DIR%\Install-CursorProxyBridgeTask.ps1' -Verb RunAs -Wait"
)

tasklist /FI "IMAGENAME eq ProxyBridge_CLI.exe" | find /I "ProxyBridge_CLI.exe" >nul
if errorlevel 1 (
  schtasks /Run /TN "%TASK%" >nul
  timeout /t 2 /nobreak >nul
)

start "" "%CURSOR%" --disable-quic
exit /b 0
