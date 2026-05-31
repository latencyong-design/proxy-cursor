@{
    CursorPath      = Join-Path $env:LOCALAPPDATA "Programs\cursor\Cursor.exe"
    ProxyBridgePath = "C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe"
    ProxyUri        = "socks5://127.0.0.1:10808"
    Rule            = "Cursor.exe:*:*:TCP:PROXY"
    DnsViaProxy     = $false
    DisableCursorQuic = $true
    Verbose         = 0
}
