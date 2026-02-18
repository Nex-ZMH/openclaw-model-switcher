@ECHO off
setlocal

if "%~1"=="gateway" (
    shift
    goto :run_wrapper
) else (
    goto :run_original
)

:run_wrapper
if "%~1"=="" (
    powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.openclaw\model-switch\openclaw-wrapper.ps1"
    exit /b %ERRORLEVEL%
) else (
    powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.openclaw\model-switch\openclaw-wrapper.ps1" %*
    exit /b %ERRORLEVEL%
)

:run_original
node "%APPDATA%\npm\node_modules\openclaw\openclaw.mjs" %*
exit /b %ERRORLEVEL%
