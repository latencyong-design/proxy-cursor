$ErrorActionPreference = "Stop"

$config = & (Join-Path $PSScriptRoot "Get-CursorProxyBridgeConfig.ps1")

if (-not (Test-Path -LiteralPath $config.ProxyBridgePath)) {
    throw "ProxyBridge not found: $($config.ProxyBridgePath)"
}

New-Item -ItemType Directory -Force -Path $config.StateDir | Out-Null

$dnsViaProxy = if ($config.DnsViaProxy) { "true" } else { "false" }
$arguments = @(
    "--proxy", $config.ProxyUri,
    "--rule", $config.Rule,
    "--dns-via-proxy", $dnsViaProxy,
    "--verbose", [string]$config.Verbose
)

$process = Start-Process -FilePath $config.ProxyBridgePath -ArgumentList $arguments -WindowStyle Hidden -PassThru
[System.IO.File]::WriteAllText($config.PidFile, [string]$process.Id, [System.Text.UTF8Encoding]::new($false))
