@echo off
echo ========================================
echo BaniTalk Admin Dashboard
echo ========================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed!
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo Download the LTS version and run the installer.
    echo.
    pause
    exit /b 1
)

echo [OK] Node.js is installed
node --version
npm --version
echo.

REM Check if node_modules exists
if not exist "node_modules\" (
    echo [INFO] Installing dependencies...
    echo This will take 2-3 minutes...
    echo.
    call npm install
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo [ERROR] Failed to install dependencies!
        pause
        exit /b 1
    )
    echo.
    echo [OK] Dependencies installed successfully!
    echo.
)

echo ========================================
echo Starting development server...
echo ========================================
echo.
echo The dashboard will open at: http://localhost:3000
echo.
echo Login with:
echo   Email: admin@talkin.app
echo   Password: TalkinAdmin@2026!
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

call npm run dev

pause
