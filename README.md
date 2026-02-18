# OpenClaw Model Switcher

English | [中文](README_CN.md)

An interactive model switcher for [OpenClaw](https://github.com/sst/openclaw) with a beautiful terminal UI.

![Demo](screenshot.png)

## Features

- Interactive model selection with arrow keys
- Space to mark, Enter to confirm
- Automatic model detection from `openclaw.json`
- Command-line arguments for scripting
- Cross-platform support (Windows now, Linux/macOS planned)

## Installation

### Quick Install (Windows)

```powershell
irm https://raw.githubusercontent.com/Nex-ZMH/openclaw-model-switcher/main/install.ps1 | iex
```

### Manual Install

```bash
git clone https://github.com/Nex-ZMH/openclaw-model-switcher.git
cd openclaw-model-switcher
.\install.ps1
```

Restart your terminal after installation.

## Usage

### Interactive Mode

```bash
openclaw gateway
```

This will display an interactive menu:

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

### Keyboard Controls

| Key | Action |
|-----|--------|
| ↑/↓ | Navigate through models |
| Space | Mark/Unmark model |
| Enter | Confirm selection and start |
| Q | Quit without starting |

### Command Line Options

```bash
openclaw gateway                  # Interactive selection
openclaw gateway --skip           # Skip selection, start directly
openclaw gateway --noselect       # Same as --skip
openclaw gateway --model <id>     # Directly select model
openclaw gateway --list           # List available models
openclaw gateway --help           # Show help
```

### Examples

```bash
# Select model interactively
openclaw gateway

# Start with a specific model
openclaw gateway --model qwen-bailian/kimi-k2.5

# List all configured models
openclaw gateway --list

# Start without changing model
openclaw gateway --skip
```

## Uninstallation

```powershell
.\uninstall.ps1
```

Or:

```powershell
irm https://raw.githubusercontent.com/Nex-ZMH/openclaw-model-switcher/main/uninstall.ps1 | iex
```

## Requirements

- [OpenClaw](https://github.com/sst/openclaw) installed globally via npm
- PowerShell 5.1+ (Windows)
- Node.js

## How It Works

The switcher reads model configurations from `~/.openclaw/openclaw.json` and modifies the `agents.defaults.model.primary` field when you select a model.

## Roadmap

- [ ] Linux support (bash script)
- [ ] macOS support
- [ ] Model search/filter
- [ ] Recent models history

## Author

[Nex-ZMH](https://github.com/Nex-ZMH)

## License

[MIT](LICENSE)
