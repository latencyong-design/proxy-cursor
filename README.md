# proxy cursor

English | [中文](#中文)

Force Cursor's own processes through a local proxy without enabling global TUN.

This project is a small Windows helper for Cursor users whose Cursor child
processes ignore the normal Windows system proxy. It starts ProxyBridge in the
background and routes only `Cursor.exe` TCP traffic to a local SOCKS5 proxy.

The practical goal is to make Cursor use your intended proxy route consistently,
so advanced provider models can be selected directly instead of falling back to
`Auto` because some Cursor requests bypass the proxy.

## What It Does

- Starts ProxyBridge without a visible console window.
- Creates a scheduled task named `CursorProxyBridge`.
- Adds one process rule: `Cursor.exe:*:*:TCP:PROXY`.
- Sends Cursor traffic to `socks5://127.0.0.1:10808`.
- Keeps DNS via Proxy disabled.
- Starts Cursor after the helper is running.
- Leaves other applications alone.

## Requirements

- Windows 10/11.
- Cursor installed at `%LOCALAPPDATA%\Programs\cursor\Cursor.exe`.
- ProxyBridge installed at `C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe`.
- A local proxy listening on `127.0.0.1:10808`, for example v2rayN.

ProxyBridge:

https://github.com/InterceptSuite/ProxyBridge

## Download

Download the latest release zip from:

https://github.com/latencyong-design/proxy-cursor/releases

Extract it anywhere, then run:

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

The first run may show a UAC prompt because ProxyBridge uses WinDivert and needs
administrator privileges.

## Usage

Start Cursor with forced proxy:

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

Stop the helper:

```bat
scripts\Stop-CursorProxyBridge.bat
```

Check status:

```bat
scripts\Status-CursorProxyBridge.bat
```

## Customize

The default local proxy is:

```text
socks5://127.0.0.1:10808
```

To change it, edit:

```text
scripts\Start-CursorProxyBridgeHidden.vbs
```

Then reinstall the scheduled task:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\Install-CursorProxyBridgeTask.ps1
```

## Notes

This is not a general VPN or TUN replacement. It is intentionally narrow: only
`Cursor.exe` is proxied, while other software keeps using its normal network
route.

Use this only with services and models you are allowed to access under their
terms and your local laws.

---

## 中文

[English](#proxy-cursor) | 中文

在不开全局 TUN 的情况下，强制 Cursor 自身进程走本地代理。

这个项目是一个 Windows 小工具，适合遇到 Cursor 子进程不遵守 Windows
系统代理的情况。它会在后台启动 ProxyBridge，并且只把 `Cursor.exe` 的 TCP
流量转发到本机 SOCKS5 代理。

实际目的：让 Cursor 稳定走你指定的代理出口，从而可以直接选择 Cursor
里的高级模型，而不是因为部分请求绕过代理，只能退回 `Auto` 模式。

## 功能

- 后台启动 ProxyBridge，不显示黑色控制台窗口。
- 创建计划任务：`CursorProxyBridge`。
- 添加单一进程规则：`Cursor.exe:*:*:TCP:PROXY`。
- 把 Cursor 流量转发到 `socks5://127.0.0.1:10808`。
- 关闭 DNS via Proxy。
- 启动代理后自动打开 Cursor。
- 不接管其他应用。

## 依赖

- Windows 10/11。
- Cursor 安装在 `%LOCALAPPDATA%\Programs\cursor\Cursor.exe`。
- ProxyBridge 安装在 `C:\Program Files\ProxyBridge\ProxyBridge_CLI.exe`。
- 本机已有代理监听 `127.0.0.1:10808`，例如 v2rayN。

ProxyBridge：

https://github.com/InterceptSuite/ProxyBridge

## 下载

从 Release 下载最新版 zip：

https://github.com/latencyong-design/proxy-cursor/releases

解压到任意目录，然后运行：

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

第一次运行可能会弹出 UAC，因为 ProxyBridge 使用 WinDivert，需要管理员权限。

## 使用

强制代理并启动 Cursor：

```bat
Start_Cursor_ProxyBridge_Silent.bat
```

停止后台代理：

```bat
scripts\Stop-CursorProxyBridge.bat
```

查看状态：

```bat
scripts\Status-CursorProxyBridge.bat
```

## 自定义

默认本地代理地址是：

```text
socks5://127.0.0.1:10808
```

如果需要修改，编辑：

```text
scripts\Start-CursorProxyBridgeHidden.vbs
```

然后重新安装计划任务：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\Install-CursorProxyBridgeTask.ps1
```

## 说明

这不是通用 VPN，也不是 TUN 替代品。它的范围很窄：只代理 `Cursor.exe`，
其他软件仍然走原来的网络路径。

请只在服务条款和当地法律允许的范围内使用相关服务和模型。
