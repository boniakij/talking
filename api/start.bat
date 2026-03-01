@echo off
echo ========================================
echo BaniTalk API Server
echo ========================================
echo.

REM Check if PHP is installed
where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PHP is not installed!
    echo Please run setup.bat first
    pause
    exit /b 1
)

REM Check if vendor folder exists
if not exist "vendor\" (
    echo [ERROR] Dependencies not installed!
    echo Please run setup.bat first
    pause
    exit /b 1
)

REM Check if .env exists
if not exist ".env" (
    echo [ERROR] .env file not found!
    echo Please run setup.bat first
    pause
    exit /b 1
)

REM Check if database exists
if not exist "database\database.sqlite" (
    echo [ERROR] Database not found!
    echo Please run setup.bat first
    pause
    exit /b 1
)

echo [OK] All checks passed
echo.
echo ========================================
echo Starting Laravel Development Server
echo ========================================
echo.
echo API URL: http://localhost:8000
echo.
echo Test Credentials:
echo   Super Admin: admin@talkin.app / TalkinAdmin@2026!
echo   Admin: admin@test.com / AdminPass123!
echo.
echo API Endpoints:
echo   POST /api/v1/auth/login
echo   GET  /api/v1/admin/users
echo   GET  /api/v1/admin/analytics/overview
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

call php artisan serve

pause
