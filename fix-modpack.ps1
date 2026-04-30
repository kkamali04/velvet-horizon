# Velvet Horizon - One-Click Modpack Fix
# Usage: right-click this file -> Run with PowerShell
# Or in PowerShell: powershell -ExecutionPolicy Bypass -File fix-modpack.ps1

$ErrorActionPreference = 'Stop'
Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "  Velvet Horizon - Modpack Fix" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""

$mods = "$env:APPDATA\ATLauncher\instances\VelvetHorizon\mods"
$disabled = "$env:APPDATA\ATLauncher\instances\VelvetHorizon\disabledmods"

if (-not (Test-Path $mods)) {
    Write-Host "[!] No VelvetHorizon instance found at $mods" -ForegroundColor Red
    Write-Host "    Install ATLauncher and All The Mods 10 first, then run join.bat from the GitHub repo."
    Read-Host "Press Enter to exit"
    exit 1
}

New-Item -ItemType Directory -Force -Path $disabled | Out-Null

$broken = @(
    'creaturechat-3.0.0+1.21.1-neoforge.jar',
    'embeddium-1.0.15+mc1.21.1.jar',
    'create-1.21.1-6.0.9.jar',
    'monocle-0.2.3.ms.jar',
    'cc-tweaked-1.21.1-forge-1.113.1.jar',
    'amendments-1.21-2.0.15-neoforge.jar',
    'create_hypertube-0.4.0-NEOFORGE.jar',
    'Design-n-Decor-1.21.1-2.1.0.jar',
    'reforgedplaymod-1.21.8-0.3.jar'
)

Write-Host "[1/4] Quarantining broken mods..."
$moved = 0
foreach ($jar in $broken) {
    $src = Join-Path $mods $jar
    if (Test-Path $src) {
        Move-Item -Force -Path $src -Destination (Join-Path $disabled $jar)
        Write-Host "      moved $jar"
        $moved++
    }
}
Write-Host "      $moved mod(s) quarantined"

Write-Host ""
Write-Host "[2/4] Downloading Sodium NeoForge 0.6.13..."
$sodiumPath = Join-Path $mods 'sodium-neoforge-0.6.13+mc1.21.1.jar'
if (-not (Test-Path $sodiumPath)) {
    $url = 'https://cdn.modrinth.com/data/AANobbMI/versions/Pb3OXVqC/sodium-neoforge-0.6.13%2Bmc1.21.1.jar'
    Invoke-WebRequest -Uri $url -OutFile $sodiumPath -UseBasicParsing
    Write-Host "      Sodium installed"
} else {
    Write-Host "      Sodium already present"
}

Write-Host ""
Write-Host "[3/4] Downloading Create 6.0.10..."
$createPath = Join-Path $mods 'create-1.21.1-6.0.10.jar'
if (-not (Test-Path $createPath)) {
    $createUrl = 'https://cdn.modrinth.com/data/LNytGWDc/versions/UjX6dr61/create-1.21.1-6.0.10.jar'
    try {
        Invoke-WebRequest -Uri $createUrl -OutFile $createPath -UseBasicParsing
        Write-Host "      Create 6.0.10 installed"
    } catch {
        Write-Host "      [!] Create 6.0.10 download failed. Get it manually from: https://modrinth.com/mod/create/versions?l=neoforge&g=1.21.1" -ForegroundColor Yellow
    }
} else {
    Write-Host "      Create 6.0.10 already present"
}

Write-Host ""
Write-Host "[4/6] Downloading Citadel 2.7.0 (required by Alex's Mobs)..."
$citadelPath = Join-Path $mods 'citadel-2.7.0-1.21.1.jar'
if (-not (Test-Path $citadelPath)) {
    try {
        Invoke-WebRequest -Uri 'https://cdn.modrinth.com/data/jJfV67b1/versions/uzrkhBpn/citadel-2.7.0-1.21.1.jar' -OutFile $citadelPath -UseBasicParsing
        Write-Host "      Citadel installed"
    } catch {
        Write-Host "      [!] Citadel download failed. Manual: https://modrinth.com/mod/citadel/versions?l=neoforge&g=1.21.1" -ForegroundColor Yellow
    }
} else {
    Write-Host "      Citadel already present"
}

Write-Host ""
Write-Host "[5/6] Downloading Sable 1.2.2 (required by Aeronautics)..."
$sablePath = Join-Path $mods 'sable-neoforge-1.21.1-1.2.2.jar'
if (-not (Test-Path $sablePath)) {
    try {
        Invoke-WebRequest -Uri 'https://cdn.modrinth.com/data/T9PomCSv/versions/3FMsUjO4/sable-neoforge-1.21.1-1.2.2.jar' -OutFile $sablePath -UseBasicParsing
        Write-Host "      Sable installed"
    } catch {
        Write-Host "      [!] Sable download failed. Manual: https://modrinth.com/mod/sable/versions?l=neoforge&g=1.21.1" -ForegroundColor Yellow
    }
} else {
    Write-Host "      Sable already present"
}

Write-Host ""
Write-Host "[6/6] Done. Launch ATLauncher -> VelvetHorizon -> Multiplayer -> play.cognesia.live" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to exit"
