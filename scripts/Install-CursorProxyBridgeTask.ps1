$ErrorActionPreference = "Stop"

$taskName = "CursorProxyBridge"
$launcher = Join-Path $PSScriptRoot "Start-CursorProxyBridgeHidden.vbs"
$proxyBridge = "C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe"

if (-not (Test-Path -LiteralPath $proxyBridge)) {
    throw "ProxyBridge not found: $proxyBridge"
}

if (-not (Test-Path -LiteralPath $launcher)) {
    throw "Launcher not found: $launcher"
}

$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$launcher`""
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -ExecutionTimeLimit 0 -MultipleInstances IgnoreNew -Hidden

Register-ScheduledTask -TaskName $taskName -Force -Action $action -Principal $principal -Settings $settings | Out-Null
Write-Host "Registered hidden task: $taskName"
