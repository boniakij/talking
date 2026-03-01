# 🚀 BaniTalk API - Complete Setup Guide

## Prerequisites

Before starting, you need to install:

### 1. PHP 8.2 or Higher
**Download PHP:**
- Visit: https://windows.php.net/download/
- Download: **PHP 8.2+ (Thread Safe)**
- Extract to: `C:\php`
- Add to PATH: `C:\php`

**Verify Installation:**
```bash
php --version
```

### 2. Composer (PHP Package Manager)
**Download Composer:**
- Visit: https://getcomposer.org/download/
- Download: **Composer-Setup.exe**
- Run installer (it will find PHP automatically)

**Verify Installation:**
```bash
composer --version
```

### 3. Database (SQLite - Already Configured!)
✅ The project is configured to use SQLite (no MySQL needed!)
✅ Database file will be created automatically

---

## 🎯 Quick Start (3 Steps)

### Step 1: Install Dependencies
```bash
cd api
composer install
```

### Step 2: Setup Environment
```bash
# Copy environment file
copy .env.example .env

# Generate application key
php artisan key:generate

# Create database file
type nul > database\database.sqlite
```

### Step 3: Run Migrations & Seeders
```bash
# Run migrations
php artisan migrate

# Seed test data
php artisan db:seed
```

### Step 4: Start Server
```bash
php artisan serve
```

✅ API will be available at: `http://localhost:8000`

---

## 📦 What Gets Installed

When you run `composer install`:

**Core Packages:**
- Laravel Framework 12.0
- Laravel Sanctum 4.3 (Authentication)
- Laravel Tinker 2.10 (REPL)

**Development Tools:**
- PHPUnit (Testing)
- Laravel Pail (Log viewer)
- Laravel Pint (Code formatter)
- Faker (Test data)

**Total Size:** ~50-80 MB (vendor folder)

---

## 🔧 Detailed Setup Steps

### 1. Install PHP

**Option A: Using Chocolatey (Recommended)**
```bash
# Install Chocolatey first (if not installed)
# Then install PHP
choco install php --version=8.2

# Verify
php --version
```

**Option B: Manual Installation**
1. Download PHP 8.2+ from https://windows.php.net/download/
2. Extract to `C:\php`
3. Add to System PATH:
   - Open System Properties → Environment Variables
   - Edit PATH variable
   - Add: `C:\php`
4. Restart terminal

**Enable Required Extensions:**
Edit `C:\php\php.ini` and uncomment these lines:
```ini
extension=openssl
extension=pdo_sqlite
extension=sqlite3
extension=mbstring
extension=fileinfo
```

### 2. Install Composer

1. Download from: https://getcomposer.org/Composer-Setup.exe
2. Run installer
3. Follow wizard (it will detect PHP)
4. Restart terminal
5. Verify: `composer --version`

### 3. Setup Project

```bash
# Navigate to API folder
cd D:\Boniyeamin\talking\api

# Install dependencies
composer install

# Copy environment file
copy .env.example .env

# Generate application key
php artisan key:generate

# Create SQLite database
type nul > database\database.sqlite

# Run migrations
php artisan migrate

# Seed test data (optional but recommended)
php artisan db:seed
```

---

## 🗄️ Database Configuration

The project uses **SQLite** by default (no MySQL needed!).

**Current Configuration (`.env`):**
```env
DB_CONNECTION=sqlite
# DB_HOST, DB_PORT, DB_DATABASE are commented out
```

**Database Location:**
```
api/database/database.sqlite
```

### Switch to MySQL (Optional)

If you prefer MySQL:

1. Install MySQL/MariaDB
2. Create database: `banitalk`
3. Update `.env`:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=banitalk
DB_USERNAME=root
DB_PASSWORD=your_password
```
4. Run migrations: `php artisan migrate`

---

## 👥 Test Accounts

After running `php artisan db:seed`, you'll have these accounts:

### Super Admin
```
Email: admin@talkin.app
Password: TalkinAdmin@2026!
Role: super_admin
```

### Admin
```
Email: admin@test.com
Password: AdminPass123!
Role: admin
```

### Test Users
```
sarah.johnson@test.com - TestPass123!
carlos.rodriguez@test.com - TestPass123!
emma.chen@test.com - TestPass123!
ahmed.hassan@test.com - TestPass123!
maria.silva@test.com - TestPass123!
```

---

## 🚀 Running the API

### Development Server
```bash
php artisan serve
```
API available at: `http://localhost:8000`

### With Custom Port
```bash
php artisan serve --port=8080
```

### With Custom Host (for network access)
```bash
php artisan serve --host=0.0.0.0 --port=8000
```

---

## 🧪 Testing the API

### Test Login Endpoint
```bash
curl -X POST http://localhost:8000/api/v1/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"admin@talkin.app\",\"password\":\"TalkinAdmin@2026!\"}"
```

### Test Health Check
```bash
curl http://localhost:8000/up
```

### Using Postman
1. Import collection from `docs/postman/`
2. Set base URL: `http://localhost:8000/api/v1`
3. Login to get token
4. Add token to Authorization header

---

## 📝 Available Artisan Commands

```bash
# View all routes
php artisan route:list

# Clear caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Run tests
php artisan test

# View logs
php artisan pail

# Database commands
php artisan migrate          # Run migrations
php artisan migrate:fresh    # Drop all tables and re-run
php artisan migrate:refresh  # Rollback and re-run
php artisan db:seed          # Run seeders
php artisan migrate:fresh --seed  # Fresh install with data

# Create new files
php artisan make:controller UserController
php artisan make:model Post
php artisan make:migration create_posts_table
```

---

## 🔌 API Endpoints

### Authentication
```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
POST   /api/v1/auth/refresh
```

### Admin (Requires Authentication)
```
GET    /api/v1/admin/users
GET    /api/v1/admin/users/{id}
POST   /api/v1/admin/users/{id}/suspend
POST   /api/v1/admin/users/{id}/ban
POST   /api/v1/admin/users/{id}/restore
GET    /api/v1/admin/reports
GET    /api/v1/admin/analytics/overview
```

**Full API Documentation:** See `docs/blueprint/api-endpoints.md`

---

## 🐛 Troubleshooting

### Issue: "composer: command not found"
**Solution:** Install Composer from https://getcomposer.org/

### Issue: "php: command not found"
**Solution:** Install PHP 8.2+ and add to PATH

### Issue: "could not find driver"
**Solution:** Enable SQLite extension in `php.ini`:
```ini
extension=pdo_sqlite
extension=sqlite3
```

### Issue: "Permission denied" on database.sqlite
**Solution:** 
```bash
# Windows
icacls database\database.sqlite /grant Everyone:F
```

### Issue: "Class not found"
**Solution:**
```bash
composer dump-autoload
php artisan config:clear
```

### Issue: "Migration failed"
**Solution:**
```bash
# Delete database and start fresh
del database\database.sqlite
type nul > database\database.sqlite
php artisan migrate:fresh --seed
```

### Issue: Port 8000 already in use
**Solution:**
```bash
# Use different port
php artisan serve --port=8080
```

---

## 🔒 Security Configuration

### CORS Setup
The API is configured to accept requests from:
- `http://localhost:3000` (Frontend dev server)
- `http://localhost:5173` (Vite default)

To add more origins, edit `config/cors.php`

### API Rate Limiting
Default: 60 requests per minute per IP

To change, edit `app/Http/Kernel.php`

---

## 📊 Database Schema

The API includes these main tables:
- users
- profiles
- conversations
- messages
- posts
- comments
- gifts
- voice_rooms
- reports
- notifications

**View Schema:** Check `database/migrations/` folder

---

## 🔄 Development Workflow

1. **Make changes** to code
2. **Clear cache** if needed: `php artisan config:clear`
3. **Run migrations** if database changed: `php artisan migrate`
4. **Test endpoints** using Postman or curl
5. **Check logs**: `php artisan pail` or `storage/logs/laravel.log`

---

## 📚 Additional Resources

- **Laravel Docs:** https://laravel.com/docs
- **API Endpoints:** `docs/blueprint/api-endpoints.md`
- **Testing Status:** `docs/qa/TESTING_STATUS.md`
- **Test Credentials:** `docs/qa/CREDENTIALS.md`

---

## 🎯 Next Steps

After setup:
1. ✅ API running on `http://localhost:8000`
2. ✅ Test login with admin credentials
3. ✅ Start frontend: `cd frontend && npm run dev`
4. ✅ Access admin dashboard: `http://localhost:3000`

---

## 💡 Tips

- **Keep terminal open** while API is running
- **Use Laravel Pail** for real-time logs: `php artisan pail`
- **Run tests** before committing: `php artisan test`
- **Check routes** anytime: `php artisan route:list`

---

**Ready to start? Run the setup commands!** 🚀
