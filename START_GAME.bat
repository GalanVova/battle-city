@echo off
setlocal
set "ROOT=%~dp0"
cd /d "%ROOT%"

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
    %PYTHON% -m pip install pygame --no-cache-dir --timeout 120 --retries 10
    if errorlevel 1 (
        echo.
        echo Failed to install pygame.
        pause
        exit /b 1
    )
)

echo Starting Battle City...
echo.
%PYTHON% battle_city\__main__.py
set "EXIT_CODE=%errorlevel%"

echo.
echo ----------------------------------------
echo Battle City finished.
echo Exit code: %EXIT_CODE%
echo ----------------------------------------
echo.
pause
exit /b %EXIT_CODE%
