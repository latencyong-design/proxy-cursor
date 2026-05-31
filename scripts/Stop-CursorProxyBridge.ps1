$ErrorActionPreference = "Stop"

$taskName = "CursorProxyBridge"
$config = & (Join-Path $PSScriptRoot "Get-CursorProxyBridgeConfig.ps1")

schtasks.exe /End /TN $taskName *> $null

if (-not (Test-Path -LiteralPath $config.PidFile)) {
    Write-Host "No proxy-cursor PID file found. Not killing unrelated ProxyBridge_CLI.exe processes."
    exit 0
}

$raw = (Get-Content -LiteralPath $config.PidFile -Raw).Trim()
$pidValue = 0
if (-not [int]::TryParse($raw, [ref]$pidValue)) {
    Remove-Item -LiteralPath $config.PidFile -Force
    throw "Invalid PID file removed: $($config.PidFile)"
}

$process = Get-Process -Id $pidValue -ErrorAction SilentlyContinue
if ($null -ne $process -and $process.ProcessName -eq "ProxyBridge_CLI") {
    Stop-Process -Id $pidValue -Force
    Write-Host "Stopped ProxyBridge_CLI.exe PID $pidValue"
} else {
    Write-Host "Recorded ProxyBridge_CLI.exe PID is not running: $pidValue"
}

Remove-Item -LiteralPath $config.PidFile -Force -ErrorAction SilentlyContinue
