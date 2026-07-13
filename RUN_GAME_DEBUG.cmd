@echo off
set "ROOT=%~dp0"
start "Battle City Debug" cmd /k "cd /d ""%ROOT%"" && py battle_city\__main__.py"
