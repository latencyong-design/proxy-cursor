# proxy-cursor

English | [中文](#中文)

Run Cursor through ProxyBridge without enabling a global TUN/VPN route.

proxy-cursor is a small Windows helper that starts ProxyBridge in the
background and routes only `Cursor.exe` TCP traffic to a local SOCKS5 or HTTP
proxy. Other applications keep their normal network route.

## Platform Support

proxy-cursor is Windows-only.

It depends on Windows Scheduled Tasks and ProxyBridge's Windows packet
interception path. macOS and Linux need different networking primitives and are
not supported by this release line.

## What It Does

- Registers a Windows scheduled task named `CursorProxyBridge`.
- Starts ProxyBridge without a visible console window.
- Adds one process rule by default: `Cursor.exe:*:*:TCP:PROXY`.
- Uses `socks5://127.0.0.1:10808` by default.
- Starts Cursor after the helper is running.
- Records the ProxyBridge PID it started, so the stop script does not kill
  unrelated ProxyBridge instances.

## Requirements

- Windows 10/11.
- Cursor installed at `%LOCALAPPDATA%\Programs\cursor\Cursor.exe`.
- ProxyBridge installed at `C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe`.
- A local proxy listening on `127.0.0.1:10808` by default.

ProxyBridge: <https://github.com/InterceptSuite/ProxyBridge>

## Install

Download the latest release zip:

<https://github.com/latencyong-design/proxy-cursor/releases>

Use the Windows asset:

```text
proxy-cursor-windows-x64-v*.zip
```

Extract it anywhere, then run:

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

The first run may show a UAC prompt because ProxyBridge uses packet
interception on Windows and the scheduled task is registered with elevated
privileges.

## Configure

The default settings are safe to publish. Your local overrides are not.

To customize paths, proxy URI, DNS behavior, or Cursor flags, copy:

```powershell
copy .\config\proxy-cursor.config.example.ps1 .\config\proxy-cursor.config.ps1
```

Then edit:

```text
config\proxy-cursor.config.ps1
```

`config\proxy-cursor.config.ps1` is ignored by git. Do not commit proxy
credentials or private network details.

After changing config, reinstall the scheduled task:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Install-CursorProxyBridgeTask.ps1
```

If you used an older release, run the same installer once after upgrading so
the scheduled task points to the current runner.

## Usage

Start ProxyBridge and Cursor:

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

Check status:

```bat
scripts\Status-CursorProxyBridge.bat
```

Stop only the ProxyBridge process started by proxy-cursor:

```bat
scripts\Stop-CursorProxyBridge.bat
```

## Uninstall

Stop the helper, then remove the scheduled task:

```powershell
scripts\Stop-CursorProxyBridge.bat
schtasks /Delete /TN CursorProxyBridge /F
```

## Privacy and Security

This project does not need cloud credentials. Keep proxy credentials, private
proxy hosts, and local-only config out of tracked files.

This is not a general VPN or TUN replacement. It is intentionally narrow:
`Cursor.exe` is routed through ProxyBridge, while other applications keep their
normal route. Use it only with services and network routes you are allowed to
use.

## Contributing

Issues and pull requests are welcome. Use the issue templates and redact private
paths, proxy credentials, and local network details before posting logs.

## License

MIT

---

## 中文

[English](#proxy-cursor) | 中文

在不开全局 TUN/VPN 的情况下，让 Cursor 通过 ProxyBridge 走指定代理。

proxy-cursor 是一个 Windows 小工具：它会在后台启动 ProxyBridge，并且默认只把
`Cursor.exe` 的 TCP 流量转发到本地 SOCKS5 或 HTTP 代理。其他应用仍然使用原来的
网络路线。

## 平台支持

proxy-cursor 仅支持 Windows。

它依赖 Windows 计划任务，以及 ProxyBridge 在 Windows 上的网络拦截路径。macOS 和
Linux 需要不同的网络机制，不属于这个 release line 的支持范围。

## 功能

- 注册名为 `CursorProxyBridge` 的 Windows 计划任务。
- 后台启动 ProxyBridge，不显示控制台窗口。
- 默认添加进程规则：`Cursor.exe:*:*:TCP:PROXY`。
- 默认使用 `socks5://127.0.0.1:10808`。
- 代理启动后打开 Cursor。
- 记录本工具启动的 ProxyBridge PID，停止脚本不会误杀其他 ProxyBridge 实例。

## 依赖

- Windows 10/11。
- Cursor 安装在 `%LOCALAPPDATA%\Programs\cursor\Cursor.exe`。
- ProxyBridge 安装在 `C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe`。
- 默认本机代理监听 `127.0.0.1:10808`。

ProxyBridge：<https://github.com/InterceptSuite/ProxyBridge>

## 安装

从 Release 下载最新 zip：

<https://github.com/latencyong-design/proxy-cursor/releases>

请下载 Windows 资产：

```text
proxy-cursor-windows-x64-v*.zip
```

解压后运行：

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

第一次运行可能弹出 UAC。原因是 ProxyBridge 在 Windows 上使用网络拦截能力，计划任务
需要以提升权限注册。

## 配置

默认配置可以公开；你的本地覆盖配置不应该公开。

如需修改 Cursor 路径、ProxyBridge 路径、代理地址、DNS 行为或 Cursor 参数，先复制：

```powershell
copy .\config\proxy-cursor.config.example.ps1 .\config\proxy-cursor.config.ps1
```

然后编辑：

```text
config\proxy-cursor.config.ps1
```

`config\proxy-cursor.config.ps1` 已加入 `.gitignore`。不要提交代理账号密码、私有代理
地址或内网信息。

修改配置后重新安装计划任务：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Install-CursorProxyBridgeTask.ps1
```

如果你用过旧版本，升级后也建议执行一次上面的安装命令，让计划任务指向新的 runner。

## 使用

启动代理并打开 Cursor：

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

查看状态：

```bat
scripts\Status-CursorProxyBridge.bat
```

只停止 proxy-cursor 启动的 ProxyBridge 进程：

```bat
scripts\Stop-CursorProxyBridge.bat
```

## 卸载

先停止工具，再删除计划任务：

```powershell
scripts\Stop-CursorProxyBridge.bat
schtasks /Delete /TN CursorProxyBridge /F
```

## 隐私与安全

本项目不需要云端凭据。代理凭据、私有代理地址和本地覆盖配置都不应该提交到仓库。

这不是通用 VPN，也不是 TUN 替代品。它的范围很窄：只让 `Cursor.exe` 通过
ProxyBridge，其他应用保持原来的网络路线。请只在服务条款和本地法律允许的范围内使用。

## 参与贡献

欢迎提交 issue 和 pull request。公开日志前请先脱敏本地路径、代理凭据和本地网络信息。

## 许可证

MIT
