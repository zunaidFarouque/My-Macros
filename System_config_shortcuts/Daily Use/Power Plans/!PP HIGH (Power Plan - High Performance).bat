@echo off
TITLE Set High Performance
color 0C

:: Switch to High Performance
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

if %errorlevel% neq 0 (
    echo [ERROR] Failed to change power plan. Check your GUID.
    pause
    exit
)

echo [SUCCESS] System is now in HIGH PERFORMANCE mode.
timeout /t 2 >nul
exit