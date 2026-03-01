@echo off
echo ========================================
echo BaniTalk Admin Dashboard - Installation
echo ========================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed!
    echo.
    echo Please install Node.js first:
    echo 1. Visit: https://nodejs.org/
    echo 2. Download the LTS version
    echo 3. Run the installer
    echo 4. Restart this script
    echo.
    pause
    exit /b 1
)

echo [OK] Node.js is installed
node --version
npm --version
echo.

echo [INFO] Installing dependencies...
echo This will take 2-3 minutes...
echo.

call npm install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Installation failed!
    echo.
    echo Try these solutions:
    echo 1. Delete node_modules folder and try again
    echo 2. Run: npm cache clean --force
    echo 3. Check your internet connection
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo [SUCCESS] Installation complete!
echo ========================================
echo.
echo Next steps:
echo 1. Run: npm run dev
echo 2. Open: http://localhost:3000
echo 3. Login with admin@talkin.app
echo.
echo Or simply double-click: start.bat
echo ========================================
echo.

pause
