param(
    [string]$InstallPath
)

if (-not $InstallPath) {
    $InstallPath = "$env:USERPROFILE\.openclaw\model-switch"
}

Write-Host ""
Write-Host "OpenClaw Model Switcher - Uninstaller" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -like "*$InstallPath*") {
    $newPath = ($userPath -split ';' | Where-Object { $_ -ne $InstallPath -and $_ -ne '' }) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Removed from PATH: $InstallPath" -ForegroundColor Green
} else {
    Write-Host "PATH does not contain: $InstallPath" -ForegroundColor Yellow
}

if (Test-Path $InstallPath) {
    Remove-Item $InstallPath -Recurse -Force
    Write-Host "Removed directory: $InstallPath" -ForegroundColor Green
} else {
    Write-Host "Directory not found: $InstallPath" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Uninstallation complete!" -ForegroundColor Green
Write-Host "Please restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
Write-Host ""
