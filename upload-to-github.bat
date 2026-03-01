@echo off
echo ========================================
echo BaniTalk - Upload to GitHub
echo ========================================
echo.

REM Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Git is not installed!
    echo.
    echo Please install Git first:
    echo 1. Visit: https://git-scm.com/download/win
    echo 2. Download and install
    echo 3. Restart this script
    echo.
    pause
    exit /b 1
)

echo [OK] Git is installed
git --version
echo.

echo ========================================
echo Step 1: Configure Git (if needed)
echo ========================================
echo.

set /p configure="Do you need to configure Git? (yes/no): "
if /i "%configure%"=="yes" (
    echo.
    set /p username="Enter your name: "
    set /p email="Enter your email: "
    git config --global user.name "%username%"
    git config --global user.email "%email%"
    echo [OK] Git configured
    echo.
)

echo ========================================
echo Step 2: Initialize Repository
echo ========================================
echo.

if exist ".git\" (
    echo [INFO] Git repository already initialized
) else (
    echo Initializing Git repository...
    git init
    echo [OK] Repository initialized
)
echo.

echo ========================================
echo Step 3: Add Files
echo ========================================
echo.

echo Adding all files to Git...
git add .
echo [OK] Files added
echo.

echo ========================================
echo Step 4: Create Commit
echo ========================================
echo.

git commit -m "Initial commit: Complete BaniTalk platform with admin dashboard"
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] No changes to commit or already committed
)
echo.

echo ========================================
echo Step 5: Add Remote Repository
echo ========================================
echo.
echo Please enter your GitHub repository URL
echo Example: https://github.com/yourusername/banitalk.git
echo.
set /p repo_url="Repository URL: "

if "%repo_url%"=="" (
    echo [ERROR] Repository URL is required!
    pause
    exit /b 1
)

REM Check if remote already exists
git remote get-url origin >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Remote 'origin' already exists, updating...
    git remote set-url origin %repo_url%
) else (
    echo Adding remote repository...
    git remote add origin %repo_url%
)
echo [OK] Remote repository configured
echo.

echo ========================================
echo Step 6: Push to GitHub
echo ========================================
echo.

echo Setting main branch...
git branch -M main
echo.

echo Pushing to GitHub...
echo You may be prompted for credentials:
echo - Username: Your GitHub username
echo - Password: Use Personal Access Token (not password!)
echo.
echo Create token at: https://github.com/settings/tokens
echo.

git push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Push failed!
    echo.
    echo Common issues:
    echo 1. Authentication failed - Use Personal Access Token
    echo 2. Repository doesn't exist - Create it on GitHub first
    echo 3. Network issues - Check your internet connection
    echo.
    echo See GITHUB_UPLOAD.md for detailed instructions
    pause
    exit /b 1
)

echo.
echo ========================================
echo [SUCCESS] Upload Complete!
echo ========================================
echo.
echo Your project is now on GitHub!
echo.
echo Repository URL: %repo_url%
echo.
echo Next steps:
echo 1. Visit your repository on GitHub
echo 2. Add description and topics
echo 3. Enable Issues if needed
echo 4. Share with your team!
echo.
echo ========================================
echo.

pause
