param(
    [string]$InstallPath
)

if (-not $InstallPath) {
    $InstallPath = "$env:USERPROFILE\.openclaw\model-switch"
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "OpenClaw Model Switcher - Installer" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $InstallPath)) {
    New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null
    Write-Host "Created directory: $InstallPath" -ForegroundColor Green
}

$files = @("openclaw-wrapper.ps1", "openclaw.cmd")
foreach ($file in $files) {
    $src = Join-Path $ScriptDir $file
    $dst = Join-Path $InstallPath $file
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Host "Installed: $file" -ForegroundColor Green
    } else {
        Write-Host "Warning: $file not found in source directory" -ForegroundColor Yellow
    }
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$InstallPath*") {
    $newPath = "$InstallPath;$userPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added to PATH: $InstallPath" -ForegroundColor Green
} else {
    Write-Host "PATH already contains: $InstallPath" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Cyan
Write-Host "  openclaw gateway          Interactive model selection"
Write-Host "  openclaw gateway --skip   Start without selection"
Write-Host "  openclaw gateway --list   List available models"
Write-Host ""
Write-Host "Please restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
Write-Host ""
