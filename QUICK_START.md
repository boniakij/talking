# 🚀 BaniTalk - Complete Quick Start Guide

## Prerequisites Installation

### 1. Install PHP 8.2+
**Option A: Using Chocolatey (Recommended)**
```bash
choco install php --version=8.2
```

**Option B: Manual Download**
- Visit: https://windows.php.net/download/
- Download: PHP 8.2+ Thread Safe
- Extract to: `C:\php`
- Add to PATH

### 2. Install Composer
- Visit: https://getcomposer.org/download/
- Download: Composer-Setup.exe
- Run installer

### 3. Install Node.js
- Visit: https://nodejs.org/
- Download: LTS version
- Run installer

---

## 🎯 Setup (One-Time)

### Step 1: Setup API
```bash
cd api
setup.bat
```

This will:
- Install PHP dependencies
- Create .env file
- Generate app key
- Create SQLite database
- Run migrations
- Seed test data

### Step 2: Setup Frontend
```bash
cd frontend
install.bat
```

This will:
- Install Node.js dependencies
- Setup environment

---

## 🚀 Running the Application

### Option 1: Start Both Services (Easiest)
Double-click: `START_BOTH.bat` in the root folder

This opens 2 windows:
- API Server (http://localhost:8000)
- Frontend (http://localhost:3000)

### Option 2: Start Separately

**Terminal 1 - API:**
```bash
cd api
start.bat
```

**Terminal 2 - Frontend:**
```bash
cd frontend
start.bat
```

---

## 🔐 Login Credentials

### Super Admin (Full Access)
```
Email: admin@talkin.app
Password: TalkinAdmin@2026!
```

### Admin (Limited Access)
```
Email: admin@test.com
Password: AdminPass123!
```

### Test Users
```
sarah.johnson@test.com - TestPass123!
carlos.rodriguez@test.com - TestPass123!
emma.chen@test.com - TestPass123!
```

---

## 📱 Access Points

- **Frontend Dashboard:** http://localhost:3000
- **API Endpoint:** http://localhost:8000/api/v1
- **API Health Check:** http://localhost:8000/up

---

## 🧪 Quick Test

### Test API
```bash
cd api
test.bat
```

### Test Frontend
Open browser: http://localhost:3000

---

## 🔄 Reset Database

If you need to reset the database:
```bash
cd api
reset.bat
```

---

## 📁 Project Structure

```
banitalk/
├── api/                    # Laravel Backend
│   ├── setup.bat          # Setup API
│   ├── start.bat          # Start API server
│   ├── reset.bat          # Reset database
│   └── test.bat           # Test API
│
├── frontend/              # React Frontend
│   ├── install.bat        # Install dependencies
│   └── start.bat          # Start dev server
│
├── START_BOTH.bat         # Start both services
└── QUICK_START.md         # This file
```

---

## 🐛 Troubleshooting

### API Issues

**"PHP not found"**
- Install PHP 8.2+ from https://windows.php.net/download/
- Add to PATH

**"Composer not found"**
- Install from https://getcomposer.org/

**"Migration failed"**
```bash
cd api
del database\database.sqlite
setup.bat
```

### Frontend Issues

**"npm not found"**
- Install Node.js from https://nodejs.org/

**"Port 3000 in use"**
- Stop other apps using port 3000
- Or change port in `frontend/vite.config.ts`

### Both Services

**"CORS error"**
- Make sure API is running on port 8000
- Check `api/config/cors.php` allows localhost:3000

---

## 📚 Documentation

- **API Setup:** `api/API_SETUP_GUIDE.md`
- **Frontend Setup:** `frontend/SETUP.md`
- **API Endpoints:** `docs/blueprint/api-endpoints.md`
- **Test Credentials:** `docs/qa/CREDENTIALS.md`
- **Development Plan:** `docs/dev/ADMIN_DASHBOARD_PLAN.md`

---

## 🎯 Development Workflow

1. **Start services:** Run `START_BOTH.bat`
2. **Make changes** to code
3. **See changes** automatically (hot reload)
4. **Test** in browser
5. **Stop services:** Press Ctrl+C in each window

---

## 📊 Features Available

### API (Laravel)
- ✅ Authentication (JWT)
- ✅ User Management
- ✅ Admin Dashboard APIs
- ✅ Reports & Moderation
- ✅ Analytics
- ✅ 150+ Endpoints

### Frontend (React)
- ✅ Admin Login
- ✅ Dashboard Overview
- ✅ User Management
- ✅ Reports Queue
- ✅ Analytics
- ✅ Role-based Access

---

## 🎉 Success Checklist

- [ ] PHP 8.2+ installed
- [ ] Composer installed
- [ ] Node.js installed
- [ ] API setup completed (`api/setup.bat`)
- [ ] Frontend setup completed (`frontend/install.bat`)
- [ ] Both services running (`START_BOTH.bat`)
- [ ] Can access http://localhost:3000
- [ ] Can login with admin credentials
- [ ] Dashboard loads successfully

---

## 💡 Tips

- Keep both terminal windows open while developing
- Use `Ctrl+C` to stop servers
- Check `storage/logs/laravel.log` for API errors
- Check browser console for frontend errors
- Run `api/reset.bat` to reset database
- Run `frontend/install.bat` again if dependencies fail

---

## 🆘 Need Help?

1. Check this guide again
2. Review detailed setup guides:
   - `api/API_SETUP_GUIDE.md`
   - `frontend/SETUP.md`
3. Check troubleshooting sections
4. Contact development team

---

**Ready? Run `START_BOTH.bat` and start developing!** 🚀

*Last Updated: 2026-02-28*
