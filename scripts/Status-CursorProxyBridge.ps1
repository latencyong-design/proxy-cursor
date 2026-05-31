$ErrorActionPreference = "Stop"

$taskName = "CursorProxyBridge"
$config = & (Join-Path $PSScriptRoot "Get-CursorProxyBridgeConfig.ps1")

Write-Host "Scheduled task:"
schtasks.exe /Query /TN $taskName /FO LIST 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Task not registered: $taskName"
}

Write-Host ""
Write-Host "Recorded proxy-cursor process:"
if (Test-Path -LiteralPath $config.PidFile) {
    $raw = (Get-Content -LiteralPath $config.PidFile -Raw).Trim()
    $pidValue = 0
    if ([int]::TryParse($raw, [ref]$pidValue)) {
        $process = Get-Process -Id $pidValue -ErrorAction SilentlyContinue
        if ($null -ne $process -and $process.ProcessName -eq "ProxyBridge_CLI") {
            Write-Host "ProxyBridge_CLI.exe PID $pidValue is running."
        } else {
            Write-Host "Recorded PID is not running: $pidValue"
        }
    } else {
        Write-Host "Invalid PID file: $($config.PidFile)"
    }
} else {
    Write-Host "No PID file found."
}

Write-Host ""
Write-Host "All visible ProxyBridge_CLI.exe processes:"
$processes = Get-CimInstance Win32_Process -Filter "Name = 'ProxyBridge_CLI.exe'" -ErrorAction SilentlyContinue
if ($processes) {
    $processes | Select-Object ProcessId, CommandLine | Format-Table -AutoSize
} else {
    Write-Host "None"
}
