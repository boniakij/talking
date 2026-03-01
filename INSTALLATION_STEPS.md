# 📋 BaniTalk - Step-by-Step Installation

## 🎯 Complete Installation Guide

Follow these steps in order. Each step must be completed before moving to the next.

---

## Step 1: Install Prerequisites

### 1.1 Install PHP 8.2+

**Option A: Using Chocolatey (Recommended for Windows)**
```bash
# Open PowerShell as Administrator
choco install php --version=8.2
```

**Option B: Manual Installation**
1. Go to: https://windows.php.net/download/
2. Download: **PHP 8.2 Thread Safe (x64)**
3. Extract to: `C:\php`
4. Add to System PATH:
   - Right-click "This PC" → Properties
   - Advanced System Settings → Environment Variables
   - Edit "Path" → Add `C:\php`
5. Restart terminal

**Verify:**
```bash
php --version
# Should show: PHP 8.2.x
```

### 1.2 Install Composer

1. Go to: https://getcomposer.org/download/
2. Download: **Composer-Setup.exe**
3. Run installer (it will find PHP automatically)
4. Follow wizard with default settings
5. Restart terminal

**Verify:**
```bash
composer --version
# Should show: Composer version 2.x.x
```

### 1.3 Install Node.js

1. Go to: https://nodejs.org/
2. Download: **LTS version** (recommended)
3. Run installer
4. Follow wizard with default settings
5. Restart terminal

**Verify:**
```bash
node --version
npm --version
# Should show: v20.x.x and 10.x.x
```

---

## Step 2: Setup API (Backend)

### 2.1 Navigate to API folder
```bash
cd D:\Boniyeamin\talking\api
```

### 2.2 Run Setup Script
```bash
setup.bat
```

**What this does:**
- ✅ Installs PHP dependencies (composer install)
- ✅ Creates .env file
- ✅ Generates application key
- ✅ Creates SQLite database
- ✅ Runs migrations
- ✅ Seeds test data

**Expected Output:**
```
[OK] Dependencies installed
[OK] .env file created
[OK] Database file created
[OK] Migrations completed
[OK] Test data seeded
[SUCCESS] Setup Complete!
```

**Time:** 2-3 minutes

---

## Step 3: Setup Frontend (Admin Dashboard)

### 3.1 Navigate to Frontend folder
```bash
cd D:\Boniyeamin\talking\frontend
```

### 3.2 Run Install Script
```bash
install.bat
```

**What this does:**
- ✅ Installs Node.js dependencies (npm install)
- ✅ Downloads 300+ packages
- ✅ Sets up development environment

**Expected Output:**
```
[OK] Node.js is installed
[INFO] Installing dependencies...
[SUCCESS] Installation complete!
```

**Time:** 3-5 minutes

---

## Step 4: Start Both Services

### Option A: Start Both at Once (Recommended)

From the root folder:
```bash
cd D:\Boniyeamin\talking
START_BOTH.bat
```

This will open 2 windows:
- **Window 1:** API Server (http://localhost:8000)
- **Window 2:** Frontend (http://localhost:3000)

### Option B: Start Separately

**Terminal 1 - API:**
```bash
cd D:\Boniyeamin\talking\api
start.bat
```

**Terminal 2 - Frontend:**
```bash
cd D:\Boniyeamin\talking\frontend
start.bat
```

---

## Step 5: Access the Dashboard

### 5.1 Open Browser
Go to: **http://localhost:3000**

### 5.2 Login
```
Email: admin@talkin.app
Password: TalkinAdmin@2026!
```

### 5.3 Explore
You should see:
- ✅ Dashboard with statistics
- ✅ Sidebar navigation
- ✅ User menu in header
- ✅ All pages accessible

---

## 🎉 Success!

If you can see the dashboard, everything is working!

---

## 📊 Visual Checklist

```
Prerequisites:
├── [✓] PHP 8.2+ installed
├── [✓] Composer installed
└── [✓] Node.js installed

API Setup:
├── [✓] Dependencies installed
├── [✓] Database created
├── [✓] Migrations run
└── [✓] Test data seeded

Frontend Setup:
├── [✓] Dependencies installed
└── [✓] Environment configured

Running:
├── [✓] API server started (port 8000)
├── [✓] Frontend started (port 3000)
└── [✓] Can login to dashboard
```

---

## 🐛 Common Issues & Solutions

### Issue 1: "PHP not found"
**Solution:**
```bash
# Check if PHP is in PATH
where php

# If not found, add C:\php to PATH
# Then restart terminal
```

### Issue 2: "Composer not found"
**Solution:**
```bash
# Reinstall Composer from:
# https://getcomposer.org/download/
```

### Issue 3: "npm not found"
**Solution:**
```bash
# Reinstall Node.js from:
# https://nodejs.org/
```

### Issue 4: "Port 8000 already in use"
**Solution:**
```bash
# Find and kill process using port 8000
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Or change port in api/start.bat
```

### Issue 5: "Port 3000 already in use"
**Solution:**
```bash
# Change port in frontend/vite.config.ts
server: {
  port: 3001, // Change to any available port
}
```

### Issue 6: "Database error"
**Solution:**
```bash
cd api
reset.bat
```

### Issue 7: "CORS error in browser"
**Solution:**
- Make sure API is running on port 8000
- Make sure Frontend is running on port 3000
- Check api/config/cors.php allows localhost:3000

### Issue 8: "Login failed"
**Solution:**
```bash
# Reset database to recreate admin user
cd api
reset.bat
```

---

## 🔄 Reset Everything

If something goes wrong, you can reset:

### Reset API
```bash
cd api
reset.bat
```

### Reset Frontend
```bash
cd frontend
rmdir /s /q node_modules
install.bat
```

---

## 📝 Quick Reference

### Start Services
```bash
# Both at once
START_BOTH.bat

# Or separately
cd api && start.bat
cd frontend && start.bat
```

### Stop Services
Press `Ctrl+C` in each terminal window

### Test API
```bash
cd api
test.bat
```

### View API Routes
```bash
cd api
php artisan route:list
```

### View Logs
```bash
# API logs
cd api
type storage\logs\laravel.log

# Or use Laravel Pail
php artisan pail
```

---

## 🎯 Next Steps After Installation

1. ✅ Explore the dashboard
2. ✅ Try different pages (Users, Reports, Analytics)
3. ✅ Test API endpoints
4. ✅ Review documentation
5. ✅ Start customizing

---

## 📚 Additional Resources

- **Quick Start:** `QUICK_START.md`
- **API Guide:** `api/API_SETUP_GUIDE.md`
- **Frontend Guide:** `frontend/SETUP.md`
- **Complete Guide:** `PROJECT_COMPLETE.md`

---

## 💡 Pro Tips

1. **Keep terminals open** while developing
2. **Use Ctrl+C** to stop servers gracefully
3. **Check logs** if something doesn't work
4. **Reset database** if data gets corrupted
5. **Read error messages** carefully

---

## 🆘 Still Having Issues?

1. Read this guide again carefully
2. Check the troubleshooting section
3. Review detailed setup guides
4. Make sure all prerequisites are installed
5. Try resetting everything

---

**Installation should take 10-15 minutes total.**

**Good luck! 🚀**
