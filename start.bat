@echo off
REM Supabase Monitoring Stack - Quick Start Script for Windows

echo.
echo Starting Supabase Monitoring Stack...
echo.

REM Check if .env file exists
if not exist .env (
    echo Error: .env file not found!
    echo.
    echo Please copy .env.example to .env and configure your credentials:
    echo    copy .env.example .env
    echo    Then edit .env with your Supabase project details
    echo.
    pause
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not running!
    echo Please start Docker Desktop and try again.
    echo.
    pause
    exit /b 1
)

echo Configuration validated
echo.

REM Start the stack
echo Starting Docker containers...
docker-compose up -d

if %errorlevel% equ 0 (
    echo.
    echo Monitoring stack started successfully!
    echo.
    echo Access your monitoring tools:
    echo    - Grafana:      http://localhost:3000 ^(admin / admin^)
    echo    - Prometheus:   http://localhost:9090
    echo    - Alertmanager: http://localhost:9093
    echo.
    echo Waiting for services to be ready...
    timeout /t 5 /nobreak >nul
    
    echo.
    echo Checking service status...
    docker-compose ps
    
    echo.
    echo Next steps:
    echo    1. Open Grafana at http://localhost:3000
    echo    2. Login with admin / admin ^(or your configured password^)
    echo    3. Navigate to Dashboards - Supabase folder
    echo    4. Check Prometheus targets at http://localhost:9090/targets
    echo.
    echo For more information, see README.md
    echo.
) else (
    echo.
    echo Failed to start monitoring stack
    echo Check the error messages above and try again
    echo.
    pause
    exit /b 1
)

pause
