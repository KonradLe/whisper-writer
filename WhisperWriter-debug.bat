@echo off
rem Debug launcher (keeps console open so you can see status / errors / model download).
cd /d "%~dp0"
".venv\Scripts\python.exe" run.py
echo.
echo (WhisperWriter exited)
pause
