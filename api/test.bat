@echo off
echo ========================================
echo BaniTalk API - Quick Test
echo ========================================
echo.

REM Check if server is running
curl -s http://localhost:8000/up >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] API server is not running!
    echo.
    echo Please start the server first:
    echo   Run: start.bat
    echo.
    pause
    exit /b 1
)

echo [OK] API server is running
echo.

echo Testing login endpoint...
echo.

curl -X POST http://localhost:8000/api/v1/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"admin@talkin.app\",\"password\":\"TalkinAdmin@2026!\"}"

echo.
echo.
echo ========================================
echo Test Complete
echo ========================================
echo.
echo If you see a token above, the API is working!
echo.
echo Next steps:
echo 1. Copy the token from the response
echo 2. Use it in Authorization header for other requests
echo 3. Or test in Postman/Insomnia
echo.

pause
