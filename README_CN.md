# OpenClaw Model Switcher

[English](README.md) | 中文

### 简介

**OpenClaw Model Switcher** — 一款优雅的交互式模型切换工具，为您的 OpenClaw 使用体验带来全新升级。它拥有精致的终端界面，能够自动从 openclaw.json 中检测可用模型，让您在启动时轻松切换配置，无需手动编辑文件。

### 功能特性

- 🎮 **交互式选择** — 使用方向键轻松导航，空格键标记，回车键确认
- ⚡ **零配置自动化切换** — 自动检测 `openclaw.json` 并实时同步模型配置
- 🖥️ **精美 TUI ** — 清洁直观的终端界面，提供优质的命令行体验
- 🔧 **脚本友好** — 完整的命令行参数支持，满足高级用户和自动化需求
- 🌐 **跨平台支持** — 已支持 Windows，Linux 和 macOS 版本即将推出

### 安装方法
建议将该工具安装在.openclaw目录下，方便直接调用。

```powershell
# 克隆仓库
git clone https://github.com/Nex-ZMH/openclaw-model-switcher.git

# 进入目录
cd openclaw-model-switcher

# 运行安装脚本
.\install.ps1
```
重启终端即可生效。

### 使用方法

#### 交互式模式

```bash
openclaw gateway
```

显示交互式菜单：

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

#### 键盘控制键

| 按键 | 功能 |
|-----|--------|
| ↑/↓ | 上下导航选择模型 |
| Space | 标记/取消标记模型 |
| Enter | 确认选择并启动 |
| Q | 退出不启动 |

#### 命令行参数

```bash
openclaw gateway                  # 交互式选择
openclaw gateway --skip           # 跳过选择，直接启动
openclaw gateway --noselect       # 同同 --skip
openclaw gateway --model <id>     # 直接指定模型并启动
openclaw gateway --list           # 列出可用模型
openclaw gateway --help           # 显示帮助
```

#### 示例

```bash
# 交互式选择模型
openclaw gateway

# 指定模型启动
openclaw gateway --model qwen-bailian/kimi-k2.5

# 列出所有已配置的模型
openclaw gateway --list

# 不更改模型直接启动
openclaw gateway --skip
```

### 卸载

```powershell
.\uninstall.ps1
```

或：

```powershell
irm https://raw.githubusercontent.com/Nex-ZMH/openclaw-model-switcher/main/uninstall.ps1 | iex
```

### 系统要求

- [OpenClaw](https://github.com/sst/openclaw) installed globally via npm
- PowerShell 5.1+ (Windows)
- Node.js

### 工作原理

从 `~/.openclaw/openclaw.json` 读取模型配置，当你选择模型时修改 `agents.defaults.model.primary` 字段。

### 开发计划

- [ ] Linux 支持（bash 脚本）
- [ ] macOS 支持
- [ ] 搜索/过滤模型
- [ ] 最近模型历史记录

## 作者

[Nex-ZMH](https://github.com/Nex-ZMH)

## 许可证

[MIT](LICENSE)
