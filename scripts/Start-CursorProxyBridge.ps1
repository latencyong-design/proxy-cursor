$ErrorActionPreference = "Stop"

$taskName = "CursorProxyBridge"
$config = & (Join-Path $PSScriptRoot "Get-CursorProxyBridgeConfig.ps1")
$installer = Join-Path $PSScriptRoot "Install-CursorProxyBridgeTask.ps1"
$runner = Join-Path $PSScriptRoot "Run-CursorProxyBridge.ps1"

function Test-RecordedProxyBridge {
    if (-not (Test-Path -LiteralPath $config.PidFile)) {
        return $false
    }

    $raw = (Get-Content -LiteralPath $config.PidFile -Raw).Trim()
    $pidValue = 0
    if (-not [int]::TryParse($raw, [ref]$pidValue)) {
        return $false
    }

    $process = Get-Process -Id $pidValue -ErrorAction SilentlyContinue
    return ($null -ne $process -and $process.ProcessName -eq "ProxyBridge_CLI")
}

if (-not (Test-Path -LiteralPath $config.CursorPath)) {
    throw "Cursor not found: $($config.CursorPath)"
}

if (-not (Test-Path -LiteralPath $installer)) {
    throw "Installer script not found: $installer"
}

$taskXml = schtasks.exe /Query /TN $taskName /XML 2>$null
$taskExists = ($LASTEXITCODE -eq 0)
$taskTargetsCurrentRunner = ($taskXml -join "`n").Contains($runner)
if (-not $taskExists -or -not $taskTargetsCurrentRunner) {
    $installerArgs = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", "`"$installer`""
    )
    Start-Process -FilePath "powershell.exe" -ArgumentList $installerArgs -Verb RunAs -Wait
}

if (-not (Test-RecordedProxyBridge)) {
    schtasks.exe /Run /TN $taskName | Out-Null
    Start-Sleep -Seconds 2
}

$cursorArgs = @()
if ($config.DisableCursorQuic) {
    $cursorArgs += "--disable-quic"
}

if ($cursorArgs.Count -gt 0) {
    Start-Process -FilePath $config.CursorPath -ArgumentList $cursorArgs
} else {
    Start-Process -FilePath $config.CursorPath
}
