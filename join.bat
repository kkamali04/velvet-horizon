@echo off
title Velvet Horizon - One Click Setup
color 0A
echo.
echo  ===================================
echo   VELVET HORIZON - Minecraft Server
echo   KAIDO / Cognesia
echo  ===================================
echo.
echo  This script will set up everything
echo  you need to join the server.
echo.
echo  Press any key to start...
pause >nul

echo.
echo  [1/5] Checking if Java is installed...
java -version >nul 2>&1
if errorlevel 1 (
    echo  [!] Java not found. Opening download page...
    start https://adoptium.net/temurin/releases/?version=21
    echo  [!] Install Java 21, then run this script again.
    pause
    exit /b 1
)
echo  [OK] Java found!

echo.
echo  [2/5] Checking if ATLauncher is installed...
if exist "%APPDATA%\ATLauncher" (
    echo  [OK] ATLauncher found!
) else (
    echo  [!] ATLauncher not found. Opening download page...
    start https://atlauncher.com/downloads
    echo.
    echo  After installing ATLauncher:
    echo    1. Open ATLauncher
    echo    2. Go to Packs
    echo    3. Search "All the Mods 10"
    echo    4. Click Install and name it "VelvetHorizon"
    echo    5. Run this script again
    echo.
    pause
    exit /b 1
)

echo.
echo  [3/5] Checking for Velvet Horizon instance...
set "MODS_DIR=%APPDATA%\ATLauncher\instances\VelvetHorizon\mods"
if not exist "%MODS_DIR%" (
    echo.
    echo  [!] No "VelvetHorizon" instance found.
    echo.
    echo  Create it first:
    echo    1. Open ATLauncher
    echo    2. Go to Packs tab
    echo    3. Search "All the Mods 10"
    echo    4. Click New Instance
    echo    5. Name it exactly: VelvetHorizon
    echo    6. Run this script again
    echo.
    pause
    exit /b 1
)
echo  [OK] VelvetHorizon instance found!

echo.
echo  [4/5] Downloading custom mods pack...
echo        (322 MB - may take a few minutes)
echo.

set "ZIP_URL=https://github.com/kkamali04/velvet-horizon/releases/download/v1.0.1/velvet-horizon-custom-mods-v1.0.1.zip"
set "ZIP_FILE=%TEMP%\velvet-horizon-custom-mods.zip"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Write-Host '  Downloading from GitHub...';" ^
  "$ProgressPreference='SilentlyContinue';" ^
  "try {" ^
  "  Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP_FILE%' -UseBasicParsing;" ^
  "  Write-Host '  Extracting mods...';" ^
  "  Add-Type -AssemblyName System.IO.Compression.FileSystem;" ^
  "  $zip = [System.IO.Compression.ZipFile]::OpenRead('%ZIP_FILE%');" ^
  "  $count = 0;" ^
  "  foreach ($entry in $zip.Entries) {" ^
  "    if ($entry.Name -like '*.jar') {" ^
  "      $dest = Join-Path '%MODS_DIR%' $entry.Name;" ^
  "      if (-not (Test-Path $dest)) {" ^
  "        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $dest, $false);" ^
  "        $count++;" ^
  "      }" ^
  "    }" ^
  "  };" ^
  "  $zip.Dispose();" ^
  "  Remove-Item '%ZIP_FILE%' -Force;" ^
  "  Write-Host \"  [OK] Installed $count new mods\"" ^
  "} catch {" ^
  "  Write-Host \"  [FAIL] Download error: $($_.Exception.Message)\";" ^
  "  Write-Host '  Try downloading manually from:';" ^
  "  Write-Host '  https://github.com/kkamali04/velvet-horizon/releases';" ^
  "  exit 1" ^
  "}"

echo.
echo  [5/5] All done!
echo.
echo  ===================================
echo   HOW TO JOIN:
echo  ===================================
echo.
echo   1. Open ATLauncher
echo   2. Go to Instances
echo   3. Launch "VelvetHorizon"
echo   4. Multiplayer ^> Add Server
echo   5. Server IP: play.cognesia.live
echo      (backup: 178.104.226.110)
echo.
echo   Discord: https://discord.gg/sM8yXGRQ
echo   Website: https://cognesia.live
echo.
echo  ===================================
echo.
pause
