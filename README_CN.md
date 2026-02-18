# OpenClaw Model Switcher

[English](README.md) | 中文

一个为 [OpenClaw](https://github.com/sst/openclaw) 打造的交互式模型切换器，拥有精美的终端界面。

![演示](screenshot.png)

## 功能特性

- 方向键交互式选择模型
- 空格键标记，回车键确认
- 自动从 `openclaw.json` 检测模型
- 支持命令行参数，便于脚本调用
- 跨平台支持（目前支持 Windows，Linux/macOS 计划中）

## 安装

### 一键安装（Windows）

```powershell
irm https://raw.githubusercontent.com/Nex-ZMH/openclaw-model-switcher/main/install.ps1 | iex
```

### 手动安装

```bash
git clone https://github.com/Nex-ZMH/openclaw-model-switcher.git
cd openclaw-model-switcher
.\install.ps1
```

安装后请重启终端。

## 使用方法

### 交互模式

```bash
openclaw gateway
```

将显示交互式菜单：

```
  +-------------------------------------------------------+
  |               OpenClaw Gateway                        |
  +-------------------------------------------------------+
  | [*] ollama/qwen3:8b                                   |
  | [ ] qwen-portal/coder-model *                         |
  | [ ] qwen-bailian/kimi-k2.5 (kimi)                     |
  | [ ] qwen-bailian/glm-4.7 (glm47)                      |
  |                                                       |
  |   [Skip] Start OpenClaw directly                      |
  +-------------------------------------------------------+

  Up/Down: Navigate   Space: Mark   Enter: Confirm   Q: Quit
```

### 键盘操作

| 按键 | 功能 |
|-----|------|
| ↑/↓ | 上下导航选择模型 |
| Space | 标记/取消标记模型 |
| Enter | 确认选择并启动 |
| Q | 退出不启动 |

### 命令行参数

```bash
openclaw gateway                  # 交互式选择
openclaw gateway --skip           # 跳过选择，直接启动
openclaw gateway --noselect       # 同 --skip
openclaw gateway --model <id>     # 直接指定模型并启动
openclaw gateway --list           # 列出可用模型
openclaw gateway --help           # 显示帮助
```

### 示例

```bash
# 交互式选择模型
openclaw gateway

# 指定模型启动
openclaw gateway --model qwen-bailian/kimi-k2.5

# 列出所有配置的模型
openclaw gateway --list

# 不切换模型直接启动
openclaw gateway --skip
```

## 卸载

```powershell
.\uninstall.ps1
```

或：

```powershell
irm https://raw.githubusercontent.com/Nex-ZMH/openclaw-model-switcher/main/uninstall.ps1 | iex
```

## 系统要求

- 已通过 npm 全局安装 [OpenClaw](https://github.com/sst/openclaw)
- PowerShell 5.1+（Windows）
- Node.js

## 工作原理

切换器从 `~/.openclaw/openclaw.json` 读取模型配置，当你选择模型时修改 `agents.defaults.model.primary` 字段。

## 开发计划

- [ ] Linux 支持（bash 脚本）
- [ ] macOS 支持
- [ ] 模型搜索/过滤
- [ ] 最近使用模型历史

## 作者

[Nex-ZMH](https://github.com/Nex-ZMH)

## 许可证

[MIT](LICENSE)
