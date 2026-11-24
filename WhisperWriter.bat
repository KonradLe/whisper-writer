@echo off
rem Daily launcher (no console window). Run from anywhere.
cd /d "%~dp0"
start "" ".venv\Scripts\pythonw.exe" run.py
