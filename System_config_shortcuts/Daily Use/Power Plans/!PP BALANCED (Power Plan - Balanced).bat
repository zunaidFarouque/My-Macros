@echo off
TITLE Set Balanced
color 0A

:: Switch to Balanced
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e

if %errorlevel% neq 0 (
    echo [ERROR] Failed to change power plan. Check your GUID.
    pause
    exit
)

echo [SUCCESS] System is now in BALANCED mode.
timeout /t 2 >nul
exit