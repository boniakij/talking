@echo off
echo ========================================
echo BaniTalk - Start API + Frontend
echo ========================================
echo.

REM Check if PHP is installed
where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PHP is not installed!
    echo Please run api\setup.bat first
    pause
    exit /b 1
)

REM Check if Node is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed!
    echo Please install Node.js from: https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] PHP and Node.js are installed
echo.

REM Check if API is setup
if not exist "api\vendor\" (
    echo [ERROR] API not setup!
    echo Please run: api\setup.bat
    pause
    exit /b 1
)

REM Check if Frontend is setup
if not exist "frontend\node_modules\" (
    echo [ERROR] Frontend not setup!
    echo Please run: frontend\install.bat
    pause
    exit /b 1
)

echo [OK] Both API and Frontend are setup
echo.

echo ========================================
echo Starting Services...
echo ========================================
echo.
echo API will start on: http://localhost:8000
echo Frontend will start on: http://localhost:3000
echo.
echo Press Ctrl+C in each window to stop
echo ========================================
echo.

REM Start API in new window
start "BaniTalk API" cmd /k "cd api && php artisan serve"

REM Wait 3 seconds for API to start
timeout /t 3 /nobreak >nul

REM Start Frontend in new window
start "BaniTalk Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo [OK] Both services started!
echo.
echo API: http://localhost:8000
echo Frontend: http://localhost:3000
echo.
echo Login with:
echo   Email: admin@talkin.app
echo   Password: TalkinAdmin@2026!
echo.

pause
