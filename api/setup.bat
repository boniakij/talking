@echo off
echo ========================================
echo BaniTalk API - Setup Script
echo ========================================
echo.

REM Check if PHP is installed
where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PHP is not installed!
    echo.
    echo Please install PHP 8.2+ first:
    echo 1. Visit: https://windows.php.net/download/
    echo 2. Download PHP 8.2 Thread Safe
    echo 3. Extract to C:\php
    echo 4. Add C:\php to PATH
    echo 5. Restart this script
    echo.
    echo OR use Chocolatey:
    echo   choco install php --version=8.2
    echo.
    pause
    exit /b 1
)

echo [OK] PHP is installed
php --version
echo.

REM Check if Composer is installed
where composer >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Composer is not installed!
    echo.
    echo Please install Composer:
    echo 1. Visit: https://getcomposer.org/download/
    echo 2. Download Composer-Setup.exe
    echo 3. Run the installer
    echo 4. Restart this script
    echo.
    pause
    exit /b 1
)

echo [OK] Composer is installed
composer --version
echo.

echo ========================================
echo Step 1: Installing Dependencies
echo ========================================
echo This will take 2-3 minutes...
echo.

call composer install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Composer install failed!
    pause
    exit /b 1
)

echo.
echo [OK] Dependencies installed
echo.

echo ========================================
echo Step 2: Environment Configuration
echo ========================================
echo.

REM Copy .env file if it doesn't exist
if not exist ".env" (
    echo Creating .env file...
    copy .env.example .env
    echo [OK] .env file created
) else (
    echo [INFO] .env file already exists
)
echo.

REM Generate application key
echo Generating application key...
call php artisan key:generate
echo.

echo ========================================
echo Step 3: Database Setup
echo ========================================
echo.

REM Create SQLite database if it doesn't exist
if not exist "database\database.sqlite" (
    echo Creating SQLite database...
    type nul > database\database.sqlite
    echo [OK] Database file created
) else (
    echo [INFO] Database file already exists
)
echo.

REM Run migrations
echo Running database migrations...
call php artisan migrate --force

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Migration failed!
    echo.
    echo Try these solutions:
    echo 1. Delete database\database.sqlite and run setup again
    echo 2. Check PHP SQLite extension is enabled
    echo.
    pause
    exit /b 1
)

echo [OK] Migrations completed
echo.

REM Run seeders
echo Seeding test data...
call php artisan db:seed --force

if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Seeding failed, but you can continue
) else (
    echo [OK] Test data seeded
)
echo.

echo ========================================
echo [SUCCESS] Setup Complete!
echo ========================================
echo.
echo API is ready to run!
echo.
echo Next steps:
echo 1. Run: start.bat
echo 2. API will be available at: http://localhost:8000
echo.
echo Test Credentials:
echo   Email: admin@talkin.app
echo   Password: TalkinAdmin@2026!
echo.
echo ========================================
echo.

pause
