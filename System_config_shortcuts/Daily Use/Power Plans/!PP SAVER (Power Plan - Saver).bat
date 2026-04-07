@echo off
TITLE Set Power Saver
color 0E

:: Switch to Power Saver
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a

if %errorlevel% neq 0 (
    echo [ERROR] Failed to change power plan. Check your GUID.
    pause
    exit
)

echo [SUCCESS] System is now in POWER SAVER mode.
timeout /t 2 >nul
exit