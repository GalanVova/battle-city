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
        pause
        exit /b 1
    )
)

%PYTHON% -c "import pygame" >nul 2>nul
if errorlevel 1 (
    echo Installing pygame...
    %PYTHON% -m pip install pygame
    if errorlevel 1 (
        echo Failed to install pygame.
        pause
        exit /b 1
    )
)

echo Starting Battle City...
%PYTHON% __main__.py

if errorlevel 1 (
    echo.
    echo The game stopped with an error. Send a screenshot of this window.
    pause
)
endlocal
