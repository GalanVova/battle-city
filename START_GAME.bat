@echo off
setlocal
cd /d "%~dp0battle_city"
set "LOG=%~dp0ERROR_LOG.txt"

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
    set /a ATTEMPT=1

    :install_pygame
    echo Attempt %ATTEMPT% of 3...
    %PYTHON% -m pip install pygame --no-cache-dir --timeout 120 --retries 10
    if not errorlevel 1 goto pygame_ready

    if %ATTEMPT% GEQ 3 (
        echo.
        echo Failed to install pygame after 3 attempts.
        pause
        exit /b 1
    )

    set /a ATTEMPT+=1
    echo Download interrupted. Retrying in 5 seconds...
    timeout /t 5 /nobreak >nul
    goto install_pygame
)

:pygame_ready
cls
echo Starting Battle City...
echo Python command: %PYTHON%
echo Working folder: %CD%
echo.

%PYTHON% __main__.py > "%LOG%" 2>&1
set "EXITCODE=%ERRORLEVEL%"

if not "%EXITCODE%"=="0" (
    echo The game stopped with error code %EXITCODE%.
    echo.
    type "%LOG%"
    echo.
    echo The same error was saved to:
    echo %LOG%
) else (
    echo The game window was closed normally.
    if exist "%LOG%" del "%LOG%" >nul 2>nul
)

echo.
pause
endlocal
