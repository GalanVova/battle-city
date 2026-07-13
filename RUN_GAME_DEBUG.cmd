@echo off
set "ROOT=%~dp0"
start "Battle City Debug" cmd /k "set PYTHONPATH=%ROOT%&& cd /d ""%ROOT%battle_city"" && py __main__.py"
