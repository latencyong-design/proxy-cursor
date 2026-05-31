Set shell = CreateObject("WScript.Shell")
cmd = """C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe"" --proxy socks5://127.0.0.1:10808 --rule ""Cursor.exe:*:*:TCP:PROXY"" --dns-via-proxy false --verbose 0"
shell.Run cmd, 0, False
