# Phase 1: Authentication & User Management - Setup Guide

## ✅ Completed Features

### Auth Module (8 endpoints)
- ✅ POST `/api/v1/auth/register` - User registration with validation
- ✅ POST `/api/v1/auth/login` - Email/password authentication
- ✅ POST `/api/v1/auth/logout` - Token invalidation
- ✅ POST `/api/v1/auth/refresh` - JWT token refresh
- ✅ POST `/api/v1/auth/forgot-password` - Password reset email
- ✅ POST `/api/v1/auth/reset-password` - Password reset with token
- ✅ GET `/api/v1/auth/verify-email/{id}/{hash}` - Email verification
- ✅ POST `/api/v1/auth/resend-verification` - Resend verification email

### User Module (4 endpoints)
- ✅ GET `/api/v1/users/me` - Get authenticated user
- ✅ PUT `/api/v1/users/me` - Update user settings
- ✅ GET `/api/v1/users/{id}` - Get public user profile
- ✅ GET `/api/v1/users/search` - Search users by name/username

### Profile Module (5 endpoints)
- ✅ GET `/api/v1/profiles/me` - Get own profile
- ✅ PUT `/api/v1/profiles/me` - Update profile
- ✅ POST `/api/v1/profiles/me/photo` - Avatar upload
- ✅ PUT `/api/v1/profiles/me/languages` - Update languages
- ✅ GET `/api/v1/profiles/{id}` - Get user profile by ID

## 📦 Installation Steps

### 1. Install Dependencies

```bash
cd api
composer install
```

### 2. Configure Environment

Copy `.env.example` to `.env` and update:

```bash
cp .env.example .env
```

Update these values in `.env`:

```env
APP_NAME=Talkin
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=talkin
DB_USERNAME=root
DB_PASSWORD=

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="noreply@talkin.app"
MAIL_FROM_NAME="${APP_NAME}"

FILESYSTEM_DISK=public
```

### 3. Generate Application Key

```bash
php artisan key:generate
```

### 4. Run Migrations

```bash
php artisan migrate
```

### 5. Seed Database

```bash
php artisan db:seed
```

This will seed 30 common languages. You can add more languages later.

### 6. Create Storage Link

```bash
php artisan storage:link
```

### 7. Start Development Server

```bash
php artisan serve
```

The API will be available at `http://localhost:8000`

## 🧪 Testing the API

### Register a New User

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "SecurePass123",
    "password_confirmation": "SecurePass123",
    "country_code": "US",
    "native_language": "en",
    "learning_language": "es"
  }'
```

### Login

```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "SecurePass123"
  }'
```

Save the `token` from the response.

### Get Current User

```bash
curl -X GET http://localhost:8000/api/v1/users/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Update Profile

```bash
curl -X PUT http://localhost:8000/api/v1/profiles/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "display_name": "John Doe",
    "bio": "Language enthusiast learning Spanish",
    "country_code": "US",
    "gender": "male",
    "learning_goal": "study"
  }'
```

### Upload Profile Photo

```bash
curl -X POST http://localhost:8000/api/v1/profiles/me/photo \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -F "photo=@/path/to/your/photo.jpg"
```

### Search Users

```bash
curl -X GET "http://localhost:8000/api/v1/users/search?q=john" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 📁 File Structure

```
api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── BaseController.php
│   │   │       ├── AuthController.php
│   │   │       ├── UserController.php
│   │   │       └── ProfileController.php
│   │   ├── Middleware/
│   │   │   ├── ForceJsonResponse.php
│   │   │   └── UpdateLastSeen.php
│   │   ├── Requests/
│   │   │   └── Auth/
│   │   │       ├── RegisterRequest.php
│   │   │       ├── LoginRequest.php
│   │   │       ├── ForgotPasswordRequest.php
│   │   │       └── ResetPasswordRequest.php
│   │   └── Resources/
│   │       ├── UserResource.php
│   │       ├── ProfileResource.php
│   │       └── UserLanguageResource.php
│   └── Models/
│       ├── User.php
│       ├── Profile.php
│       ├── Language.php
│       └── UserLanguage.php
├── database/
│   ├── migrations/
│   │   ├── 2024_01_01_000001_create_languages_table.php
│   │   ├── 2024_01_01_000002_update_users_table.php
│   │   ├── 2024_01_01_000003_create_profiles_table.php
│   │   ├── 2024_01_01_000004_create_user_languages_table.php
│   │   └── 2024_01_01_000005_create_password_reset_tokens_table.php
│   └── seeders/
│       ├── DatabaseSeeder.php
│       └── LanguageSeeder.php
└── routes/
    └── api.php
```

## 🔐 Security Features

- ✅ Password hashing with bcrypt
- ✅ JWT token authentication via Laravel Sanctum
- ✅ Rate limiting on login (5 attempts per 15 minutes)
- ✅ Email verification
- ✅ Password reset with secure tokens
- ✅ Input validation on all endpoints
- ✅ CORS configuration
- ✅ Force JSON responses for API

## 📊 Database Schema

### users
- id, uuid, username, email, password
- provider, provider_id (for OAuth)
- role (user, admin, super_admin)
- status (active, suspended, banned)
- email_verified_at, last_seen_at

### profiles
- user_id, display_name, avatar, bio
- country_code, date_of_birth, gender
- is_public, coin_balance
- cultural_interests (JSON)
- learning_goal

### languages
- code, name, native_name, flag_emoji
- is_active

### user_languages
- user_id, language_id
- type (native, learning)
- proficiency

## 🚀 Next Steps

Phase 1 is complete! Next phases:

- **Phase 2**: Social Features (Follow/Block system)
- **Phase 3**: Chat System (Real-time messaging)
- **Phase 4**: Calls & Video (WebRTC)
- **Phase 5**: Voice Rooms
- And more...

## 📝 Notes

- OAuth (Google/Apple) endpoints are defined but require additional setup
- File uploads use local storage by default (configure S3 for production)
- Email verification requires mail configuration
- Rate limiting is configured but can be adjusted in routes

## 🐛 Troubleshooting

### Migration Errors
```bash
php artisan migrate:fresh --seed
```

### Clear Cache
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
```

### Permission Issues (Storage)
```bash
chmod -R 775 storage bootstrap/cache
```

## ✅ Status Update

Update `docs/dev/task_api.md` status for completed tasks:
- TASK-010 through TASK-031: ✅ Done
