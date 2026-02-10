@echo off
REM Supabase Monitoring Stack - Validation Script

echo.
echo ========================================
echo Supabase Monitoring Stack Validator
echo ========================================
echo.

set ERRORS=0

REM Check Docker
echo [1/6] Checking Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo    [FAIL] Docker is not installed or not in PATH
    set /a ERRORS+=1
) else (
    docker info >nul 2>&1
    if errorlevel 1 (
        echo    [FAIL] Docker is not running
        set /a ERRORS+=1
    ) else (
        echo    [PASS] Docker is running
    )
)

REM Check Docker Compose
echo [2/6] Checking Docker Compose...
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo    [FAIL] Docker Compose is not installed
    set /a ERRORS+=1
) else (
    echo    [PASS] Docker Compose is installed
)

REM Check .env file
echo [3/6] Checking .env file...
if not exist .env (
    echo    [FAIL] .env file not found
    echo           Run: copy .env.example .env
    set /a ERRORS+=1
) else (
    echo    [PASS] .env file exists
)

REM Check configuration files
echo [4/6] Checking configuration files...
set CONFIG_OK=1

if not exist docker\prometheus\prometheus.yml (
    echo    [FAIL] prometheus.yml not found
    set CONFIG_OK=0
)

if not exist docker\prometheus\rules\supabase-alerts.yml (
    echo    [FAIL] supabase-alerts.yml not found
    set CONFIG_OK=0
)

if not exist docker\grafana\provisioning\datasources\prometheus.yml (
    echo    [FAIL] Grafana datasource config not found
    set CONFIG_OK=0
)

if not exist docker\alertmanager\alertmanager.yml (
    echo    [FAIL] alertmanager.yml not found
    set CONFIG_OK=0
)

if %CONFIG_OK%==1 (
    echo    [PASS] All configuration files present
) else (
    set /a ERRORS+=1
)

REM Check dashboard
echo [5/6] Checking Grafana dashboard...
if not exist docker\grafana\dashboards\supabase-official.json (
    echo    [WARN] Official Supabase dashboard not found
    echo           This should have been downloaded automatically
    set /a ERRORS+=1
) else (
    echo    [PASS] Supabase dashboard found
)

REM Check environment variables
echo [6/6] Checking environment variables...
findstr /C:"your_service_role_key_here" .env >nul 2>&1
if not errorlevel 1 (
    echo    [WARN] SUPABASE_SERVICE_ROLE_KEY not configured
    echo           Please edit .env and set your service role key
    set /a ERRORS+=1
) else (
    echo    [PASS] Environment variables configured
)

echo.
echo ========================================

if %ERRORS%==0 (
    echo Result: ALL CHECKS PASSED
    echo.
    echo You're ready to start the monitoring stack!
    echo Run: start.bat
) else (
    echo Result: %ERRORS% ISSUE(S) FOUND
    echo.
    echo Please fix the issues above before starting
)

echo ========================================
echo.

pause
