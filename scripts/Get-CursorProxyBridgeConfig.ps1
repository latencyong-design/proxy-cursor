param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

$defaults = @{
    CursorPath        = Join-Path $env:LOCALAPPDATA "Programs\cursor\Cursor.exe"
    ProxyBridgePath   = "C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe"
    ProxyUri          = "socks5://127.0.0.1:10808"
    Rule              = "Cursor.exe:*:*:TCP:PROXY"
    DnsViaProxy       = $false
    DisableCursorQuic = $true
    Verbose           = 0
}

$configPath = Join-Path $RepositoryRoot "config\proxy-cursor.config.ps1"
if (Test-Path -LiteralPath $configPath) {
    $userConfig = & $configPath
    if ($userConfig -isnot [hashtable]) {
        throw "Config must return a PowerShell hashtable: $configPath"
    }

    foreach ($key in $userConfig.Keys) {
        if (-not $defaults.ContainsKey($key)) {
            throw "Unknown config key '$key' in $configPath"
        }
        $defaults[$key] = $userConfig[$key]
    }
}

$stateDir = Join-Path $RepositoryRoot "state"
$defaults["StateDir"] = $stateDir
$defaults["PidFile"] = Join-Path $stateDir "proxybridge.pid"

[pscustomobject]$defaults
