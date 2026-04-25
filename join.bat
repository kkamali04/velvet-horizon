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
echo  [1/4] Checking if Java is installed...
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
echo  [2/4] Checking if ATLauncher is installed...
if exist "%APPDATA%\ATLauncher\ATLauncher.exe" (
    echo  [OK] ATLauncher found!
) else (
    echo  [!] ATLauncher not found. Opening download page...
    start https://atlauncher.com/downloads
    echo.
    echo  After installing ATLauncher:
    echo    1. Open ATLauncher
    echo    2. Go to Packs
    echo    3. Search "All the Mods 10"
    echo    4. Click Install
    echo    5. Run this script again
    echo.
    pause
    exit /b 1
)

echo.
echo  [3/4] Downloading custom mods...
if exist "%APPDATA%\ATLauncher\instances\VelvetHorizon\mods" (
    echo  [OK] Velvet Horizon instance found!
    echo  Downloading mods...
    python "%~dp0setup.py" --mods-dir "%APPDATA%\ATLauncher\instances\VelvetHorizon\mods"
) else (
    echo.
    echo  [!] No "Velvet Horizon" instance found.
    echo.
    echo  You need to create the instance first:
    echo    1. Open ATLauncher
    echo    2. Go to Packs
    echo    3. Search "All the Mods 10"
    echo    4. Click Install
    echo    5. Name it "VelvetHorizon" (no space)
    echo    6. Run this script again
    echo.
    pause
    exit /b 1
)

echo.
echo  [4/4] All done!
echo.
echo  ===================================
echo   HOW TO JOIN:
echo  ===================================
echo.
echo   1. Open ATLauncher
echo   2. Go to Instances
echo   3. Launch "Velvet Horizon"
echo   4. Multiplayer ^> Add Server
echo   5. Server IP: 178.104.226.110
echo      (or: play.cognesia.live)
echo.
echo   Discord: https://discord.gg/sM8yXGRQ
echo.
echo  ===================================
echo.
pause
