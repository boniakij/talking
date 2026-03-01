@echo off
echo ========================================
echo BaniTalk API - Database Reset
echo ========================================
echo.
echo WARNING: This will delete all data!
echo.
set /p confirm="Are you sure? (yes/no): "

if /i not "%confirm%"=="yes" (
    echo.
    echo [CANCELLED] Database reset cancelled
    pause
    exit /b 0
)

echo.
echo Resetting database...
echo.

REM Delete database file
if exist "database\database.sqlite" (
    del database\database.sqlite
    echo [OK] Old database deleted
)

REM Create new database
type nul > database\database.sqlite
echo [OK] New database created
echo.

REM Run migrations
echo Running migrations...
call php artisan migrate:fresh --seed --force

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Reset failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo [SUCCESS] Database Reset Complete!
echo ========================================
echo.
echo Test accounts have been recreated:
echo   Super Admin: admin@talkin.app / TalkinAdmin@2026!
echo   Admin: admin@test.com / AdminPass123!
echo.
echo You can now start the server with: start.bat
echo ========================================
echo.

pause
