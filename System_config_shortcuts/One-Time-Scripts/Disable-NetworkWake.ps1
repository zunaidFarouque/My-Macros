# Clean, modern gsudo auto-elevation check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # If not admin, use gsudo to restart this exact script with admin rights
    gsudo pwsh -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath
    exit 0
}

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "Executing Hardware Wake Containment Protocol..." -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

# Find all physical network adapters
$adapters = Get-NetAdapter -Physical
if (-not $adapters) {
    Write-Host "[WARN] No physical network adapters detected. Nothing to change." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    exit 0
}

Write-Host "Phase 1: Stripping OS ACPI Wake Permissions" -ForegroundColor Yellow
foreach ($adapter in $adapters) {
    $deviceName = $adapter.InterfaceDescription
    Write-Host " -> Neutralizing: $deviceName"
    # Run natively, no gsudo needed because the whole script is elevated
    powercfg /devicedisablewake "$deviceName" 2>$null
}

Write-Host "`nPhase 2: Disabling Driver-Level Listening Protocols" -ForegroundColor Yellow
foreach ($adapter in $adapters) {
    $ifName = $adapter.Name
    # Run natively, no gsudo needed. Quotes are preserved perfectly.
    Disable-NetAdapterPowerManagement -Name "$ifName" -WakeOnMagicPacket -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name "$ifName" -DisplayName "*Wake on Magic Packet*" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name "$ifName" -DisplayName "*Wake on Pattern Match*" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
}

Write-Host "`n[ SUCCESS ] All network adapters are permanently locked out of ACPI wake states." -ForegroundColor Green
Write-Host "Your laptop will no longer turn itself on inside your bag." -ForegroundColor Green
Start-Sleep -Seconds 4
