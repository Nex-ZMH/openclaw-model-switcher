param(
    [string]$Model,
    [switch]$List,
    [switch]$Help,
    [switch]$NoSelect,
    [switch]$Skip
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$OpenClawDir = Join-Path $env:USERPROFILE ".openclaw"
$ConfigPath = Join-Path $OpenClawDir "openclaw.json"
$RealOpenClaw = Join-Path $env:APPDATA "npm\node_modules\openclaw\openclaw.mjs"

function Show-Help {
    Write-Host @"

OpenClaw Model Switcher
=======================

Usage:
    openclaw gateway                  Interactive model selection, then start
    openclaw gateway --skip           Skip selection, start directly
    openclaw gateway --noselect       Same as --skip
    openclaw gateway --model <id>     Directly select model and start
    openclaw gateway --list           List available models
    openclaw gateway --help           Show this help

Examples:
    openclaw gateway --model qwen-bailian/kimi-k2.5
    openclaw gateway --skip
    openclaw gateway --list

"@
}

function Get-Config {
    if (-not (Test-Path $ConfigPath)) {
        Write-Error "OpenClaw config not found: $ConfigPath"
        exit 1
    }
    return Get-Content $ConfigPath -Encoding UTF8 | ConvertFrom-Json
}

function Set-Config {
    param([object]$Config)
    $Config | ConvertTo-Json -Depth 100 | Set-Content $ConfigPath -Encoding UTF8
}

function Get-AvailableModels {
    param([object]$Config)
    
    $models = @()
    $modelsMap = $Config.agents.defaults.models
    
    if ($modelsMap) {
        $modelsMap.PSObject.Properties | ForEach-Object {
            $modelId = $_.Name
            $modelInfo = $_.Value
            $alias = if ($modelInfo.alias) { $modelInfo.alias } else { $modelId }
            $models += @{
                Id = $modelId
                Alias = $alias
                DisplayName = "$modelId ($alias)"
            }
        }
    }
    
    return $models
}

function Get-CurrentModel {
    param([object]$Config)
    return $Config.agents.defaults.model.primary
}

function List-Models {
    $config = Get-Config
    $models = Get-AvailableModels -Config $config
    $current = Get-CurrentModel -Config $config
    
    Write-Host ""
    Write-Host "Available Models:" -ForegroundColor Cyan
    Write-Host ""
    
    $models | ForEach-Object {
        $marker = if ($_.Id -eq $current) { " <-- current" } else { "" }
        $color = if ($_.Id -eq $current) { "Green" } else { "White" }
        Write-Host "  $($_.Id)$marker" -ForegroundColor $color
    }
    Write-Host ""
    Write-Host "Current: $current" -ForegroundColor Yellow
}

function Switch-Model {
    param([string]$ModelId)
    
    $config = Get-Config
    $models = Get-AvailableModels -Config $config
    
    $found = $models | Where-Object { $_.Id -eq $ModelId }
    if (-not $found) {
        Write-Host "Model '$ModelId' not found." -ForegroundColor Red
        Write-Host "Use --list to see available models." -ForegroundColor Yellow
        exit 1
    }
    
    $config.agents.defaults.model.primary = $ModelId
    Set-Config -Config $config
    
    Write-Host ""
    Write-Host "Switched to: $ModelId" -ForegroundColor Green
}

function Show-InteractiveMenu {
    param([object]$Config)
    
    $models = Get-AvailableModels -Config $Config
    $current = Get-CurrentModel -Config $Config
    
    if ($models.Count -eq 0) {
        Write-Host "No models configured." -ForegroundColor Yellow
        return $null
    }
    
    $selectedIndex = 0
    $markedIndex = -1
    for ($i = 0; $i -lt $models.Count; $i++) {
        if ($models[$i].Id -eq $current) {
            $selectedIndex = $i
            $markedIndex = $i
            break
        }
    }
    
    $skipIndex = $models.Count
    
    function Draw-Menu {
        param([int]$Selected, [int]$Marked)
        
        Clear-Host
        
        $menuWidth = 55
        $line = "-" * $menuWidth
        
        Write-Host ""
        Write-Host "  +$line+" -ForegroundColor Cyan
        Write-Host "  |" -NoNewline -ForegroundColor Cyan
        $title = "OpenClaw Gateway"
        $padding = $menuWidth - $title.Length
        Write-Host (" " * [Math]::Floor($padding / 2)) -NoNewline
        Write-Host $title -NoNewline -ForegroundColor Yellow
        Write-Host (" " * [Math]::Ceiling($padding / 2)) -NoNewline
        Write-Host "|" -ForegroundColor Cyan
        Write-Host "  +$line+" -ForegroundColor Cyan
        
        for ($i = 0; $i -lt $models.Count; $i++) {
            $model = $models[$i]
            $isCurrent = $model.Id -eq $current
            $isSelected = $i -eq $Selected
            $isMarked = $i -eq $Marked
            
            Write-Host "  |" -NoNewline -ForegroundColor Cyan
            
            if ($isMarked) {
                Write-Host " [*]" -NoNewline -ForegroundColor Green
            } elseif ($isSelected) {
                Write-Host " [ ]" -NoNewline -ForegroundColor White
            } else {
                Write-Host "     " -NoNewline
            }
            
            $displayText = $model.Id
            if ($model.Alias -and $model.Alias -ne $model.Id) {
                $displayText += " ($($model.Alias))"
            }
            
            if ($isCurrent) {
                $displayText += " *"
            }
            
            $maxLen = $menuWidth - 10
            if ($displayText.Length -gt $maxLen) {
                $displayText = $displayText.Substring(0, $maxLen - 3) + "..."
            }
            
            $textLen = $displayText.Length + 6
            $padLen = [Math]::Max(0, $menuWidth - $textLen)
            
            if ($isSelected) {
                Write-Host $displayText -NoNewline -ForegroundColor Black -BackgroundColor White
                Write-Host (" " * $padLen) -NoNewline -BackgroundColor White
            } elseif ($isMarked) {
                Write-Host $displayText -NoNewline -ForegroundColor Green
                Write-Host (" " * $padLen) -NoNewline
            } elseif ($isCurrent) {
                Write-Host $displayText -NoNewline -ForegroundColor Cyan
                Write-Host (" " * $padLen) -NoNewline
            } else {
                Write-Host $displayText -NoNewline
                Write-Host (" " * $padLen) -NoNewline
            }
            
            Write-Host "|" -ForegroundColor Cyan
        }
        
        Write-Host "  |" -NoNewline -ForegroundColor Cyan
        Write-Host (" " * ($menuWidth)) -NoNewline
        Write-Host "|" -ForegroundColor Cyan
        
        Write-Host "  |" -NoNewline -ForegroundColor Cyan
        $skipText = "[Skip] Start OpenClaw directly"
        $isSkipSelected = $Selected -eq $skipIndex
        $padLen = [Math]::Max(0, $menuWidth - $skipText.Length - 7)
        
        if ($isSkipSelected) {
            Write-Host " > " -NoNewline -ForegroundColor Green
            Write-Host $skipText -NoNewline -ForegroundColor Black -BackgroundColor White
            Write-Host (" " * $padLen) -NoNewline -BackgroundColor White
        } else {
            Write-Host "   " -NoNewline
            Write-Host $skipText -NoNewline -ForegroundColor DarkGray
            Write-Host (" " * $padLen) -NoNewline
        }
        Write-Host "|" -ForegroundColor Cyan
        
        Write-Host "  +$line+" -ForegroundColor Cyan
        
        Write-Host ""
        Write-Host "  Up/Down: Navigate   Space: Mark   Enter: Confirm   Q: Quit" -ForegroundColor DarkGray
        Write-Host ""
    }
    
    Draw-Menu -Selected $selectedIndex -Marked $markedIndex
    
    while ($true) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
        switch ($key.VirtualKeyCode) {
            38 {
                if ($selectedIndex -gt 0) {
                    $selectedIndex--
                    Draw-Menu -Selected $selectedIndex -Marked $markedIndex
                }
            }
            40 {
                if ($selectedIndex -lt $skipIndex) {
                    $selectedIndex++
                    Draw-Menu -Selected $selectedIndex -Marked $markedIndex
                }
            }
            32 {
                if ($selectedIndex -lt $skipIndex) {
                    if ($markedIndex -eq $selectedIndex) {
                        $markedIndex = -1
                    } else {
                        $markedIndex = $selectedIndex
                    }
                    Draw-Menu -Selected $selectedIndex -Marked $markedIndex
                }
            }
            13 {
                if ($selectedIndex -eq $skipIndex) {
                    return "SKIP"
                }
                $finalIndex = if ($markedIndex -ge 0) { $markedIndex } else { $selectedIndex }
                if ($finalIndex -eq $skipIndex) {
                    return "SKIP"
                }
                return $models[$finalIndex].Id
            }
            81 {
                return "QUIT"
            }
        }
    }
}

function Start-OpenClaw {
    Write-Host ""
    Write-Host "Starting OpenClaw Gateway..." -ForegroundColor Yellow
    & node $RealOpenClaw gateway
}

if ($Help) {
    Show-Help
    exit 0
}

if ($List) {
    List-Models
    exit 0
}

if ($Skip -or $NoSelect) {
    Start-OpenClaw
    exit 0
}

if ($Model) {
    Switch-Model -ModelId $Model
    Start-OpenClaw
    exit 0
}

$config = Get-Config
$selectedModel = Show-InteractiveMenu -Config $config

if ($selectedModel -eq "QUIT") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

if ($selectedModel -eq "SKIP") {
    Start-OpenClaw
    exit 0
}

if ($selectedModel) {
    Switch-Model -ModelId $selectedModel
    Start-OpenClaw
}
