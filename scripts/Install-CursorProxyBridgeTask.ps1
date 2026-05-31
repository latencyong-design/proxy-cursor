$ErrorActionPreference = "Stop"

$taskName = "CursorProxyBridge"
$config = & (Join-Path $PSScriptRoot "Get-CursorProxyBridgeConfig.ps1")
$runner = Join-Path $PSScriptRoot "Run-CursorProxyBridge.ps1"

if (-not (Test-Path -LiteralPath $config.ProxyBridgePath)) {
    throw "ProxyBridge not found: $($config.ProxyBridgePath)"
}

if (-not (Test-Path -LiteralPath $runner)) {
    throw "Runner not found: $runner"
}

$actionArgs = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$runner`""
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $actionArgs
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -ExecutionTimeLimit 0 -MultipleInstances IgnoreNew -Hidden

Register-ScheduledTask -TaskName $taskName -Force -Action $action -Principal $principal -Settings $settings | Out-Null
Write-Host "Registered hidden task: $taskName"
