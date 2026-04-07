@echo off
TITLE Permanent Delivery Optimization Neuter
color 0B

where gsudo >nul 2>&1
if errorlevel 1 (
echo [ERROR] gsudo was not found in PATH. Cannot run admin commands.
timeout /t 3 >nul
exit /b 1
)

echo =======================================================
echo 1. Restoring base service to prevent Windows Update errors...
echo =======================================================
gsudo sc config dosvc start= demand >nul
if errorlevel 1 echo [WARN] Could not set dosvc startup type to demand.
gsudo net start dosvc 2>nul
if errorlevel 1 echo [WARN] dosvc may already be running or failed to start.

echo.
echo =======================================================
echo 2. Forcing Download Mode 99 (HTTP Only, No Peering)...
echo =======================================================
gsudo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 99 /f >nul
if errorlevel 1 echo [WARN] Could not set DODownloadMode to 99.

echo.
echo =======================================================
echo 3. Forcing Cache Limit to 0 GB to protect SSD...
echo =======================================================
gsudo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DOMaxCacheSize /t REG_DWORD /d 0 /f >nul
if errorlevel 1 echo [WARN] Could not set DOMaxCacheSize to 0.
gsudo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DOAbsoluteMaxCacheSize /t REG_DWORD /d 0 /f >nul
if errorlevel 1 echo [WARN] Could not set DOAbsoluteMaxCacheSize to 0.

echo.
echo [ SUCCESS ] Delivery Optimization is permanently lobotomized.
echo Windows Update will now use direct HTTP downloads only.
timeout /t 3 >nul
exit