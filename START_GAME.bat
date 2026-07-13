@echo off
setlocal
cd /d "%~dp0battle_city"

where py >nul 2>nul
if %errorlevel%==0 (
    set "PYTHON=py"
) else (
    where python >nul 2>nul
    if %errorlevel%==0 (
        set "PYTHON=python"
    ) else (
        echo Python is not installed.
        echo Install Python 3.9 or newer and enable Add Python to PATH.
        echo.
        pause
        exit /b 1
    )
)

%PYTHON% -c "import pygame" >nul 2>nul
if errorlevel 1 (
    echo Installing pygame...
    set /a ATTEMPT=1

    :install_pygame
    echo Attempt %ATTEMPT% of 3...
    %PYTHON% -m pip install pygame --no-cache-dir --timeout 120 --retries 10
    if not errorlevel 1 goto pygame_ready

    if %ATTEMPT% GEQ 3 (
        echo.
        echo Failed to install pygame after 3 attempts.
        echo Check your Internet connection, VPN, proxy or antivirus.
        echo.
        pause
        exit /b 1
    )

    set /a ATTEMPT+=1
    echo Download interrupted. Retrying in 5 seconds...
    timeout /t 5 /nobreak >nul
    goto install_pygame
)

:pygame_ready
echo Starting Battle City...
echo.
%PYTHON% __main__.py
set "EXIT_CODE=%errorlevel%"

echo.
echo ----------------------------------------
echo Battle City finished.
echo Exit code: %EXIT_CODE%
echo ----------------------------------------
echo.
echo This window will stay open.
pause
exit /b %EXIT_CODE%
