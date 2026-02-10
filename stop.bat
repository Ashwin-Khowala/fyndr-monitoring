@echo off
REM Supabase Monitoring Stack - Stop Script for Windows

echo.
echo Stopping Supabase Monitoring Stack...
echo.

docker-compose down

if %errorlevel% equ 0 (
    echo.
    echo Monitoring stack stopped successfully!
    echo.
    echo To start again, run: start.bat
    echo To remove all data, run: docker-compose down -v
    echo.
) else (
    echo.
    echo Failed to stop monitoring stack
    echo.
)

pause
