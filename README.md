# 🌍 BaniTalk - Language Learning & Cultural Exchange Platform

> **Connect. Learn. Share. Grow.**
> A comprehensive language learning and cultural exchange platform with admin dashboard for platform management.

[![Laravel Version](https://img.shields.io/badge/Laravel-12.x-red.svg)](https://laravel.com)
[![React Version](https://img.shields.io/badge/React-18.3-blue.svg)](https://react.dev)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.4-blue.svg)](https://www.typescriptlang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

BaniTalk is a full-stack platform that connects people worldwide through:
- 💬 Real-time messaging with translation
- 📞 Voice & video calls (WebRTC)
- 🎙️ Voice rooms for community discussions
- 🤖 AI-powered speech learning
- 🎁 Virtual gift economy
- 💕 Smart partner matching

This repository includes:
- **Backend API** (Laravel 12) - RESTful API with 150+ endpoints
- **Admin Dashboard** (React + TypeScript) - Modern admin panel for platform management
- **Mobile App** (Flutter) - Cross-platform mobile application

---

## ✨ Features

### Core Platform Features
- 🔐 **Authentication** - Secure login with Sanctum, Google/Apple OAuth
- 💬 **Real-time Messaging** - WebSocket-powered chat with reactions
- 📞 **Voice & Video Calls** - WebRTC P2P calling
- 🎙️ **Voice Rooms** - Community audio rooms with Agora SDK
- 📱 **Social Feed** - Share moments with photos, videos, comments
- 🤖 **Speech Learning** - AI-powered pronunciation coach
- 🎁 **Virtual Economy** - Gifts, coins, in-app purchases
- 💕 **Partner Matching** - Discovery deck with compatibility scoring
- 🔔 **Push Notifications** - Firebase messaging

### Admin Dashboard Features
- 📊 **Dashboard Overview** - Real-time statistics and metrics
- 👥 **User Management** - Suspend, ban, restore users
- 📝 **Content Moderation** - Report queue and resolution
- 📈 **Analytics** - User, communication, and revenue analytics
- 🎁 **Gift Management** - CRUD operations for virtual gifts
- 🎙️ **Voice Room Monitoring** - Live room oversight
- 👨‍💼 **Admin Management** - Create and manage administrators
- ⚙️ **Platform Settings** - Feature flags and configurations

---

## 🛠️ Tech Stack

### Backend (API)
- **Framework:** Laravel 12
- **Language:** PHP 8.2+
- **Database:** SQLite (default) / MySQL / PostgreSQL
- **Authentication:** Laravel Sanctum (JWT)
- **Real-time:** Laravel Echo + WebSocket
- **Storage:** AWS S3 / MinIO

### Frontend (Admin Dashboard)
- **Framework:** React 18
- **Language:** TypeScript 5.4
- **Build Tool:** Vite 5.1
- **State Management:** TanStack Query + Zustand
- **Routing:** React Router 6
- **Styling:** Tailwind CSS 3.4
- **Components:** shadcn/ui (Radix UI)
- **HTTP Client:** Axios

### Mobile (APK)
- **Framework:** Flutter 3.27+
- **Language:** Dart 3.0+
- **State Management:** flutter_bloc
- **Routing:** go_router
- **Real-time:** WebRTC, Agora SDK

---

## 🚀 Quick Start

### Prerequisites

- **PHP 8.2+** - [Download](https://windows.php.net/download/)
- **Composer** - [Download](https://getcomposer.org/)
- **Node.js 18+** - [Download](https://nodejs.org/)
- **MySQL 8.0+** or **PostgreSQL 14+** (optional, SQLite works out of the box)

### Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/banitalk.git
cd banitalk
```

#### 2. Setup Backend API
```bash
cd api
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

API will be available at: `http://localhost:8000`

#### 3. Setup Admin Dashboard
```bash
cd frontend
npm install
npm run dev
```

Dashboard will be available at: `http://localhost:3000`

### Default Credentials

**Super Admin:**
```
Email: admin@talkin.app
Password: TalkinAdmin@2026!
```

**Admin:**
```
Email: admin@test.com
Password: AdminPass123!
```

---

## 📁 Project Structure

```
banitalk/
├── api/                    # Laravel Backend API
│   ├── app/               # Application code
│   ├── database/          # Migrations & seeders
│   ├── routes/            # API routes
│   └── README.md          # API documentation
│
├── frontend/              # React Admin Dashboard
│   ├── src/
│   │   ├── api/          # API client
│   │   ├── components/   # UI components
│   │   ├── features/     # Feature modules
│   │   ├── pages/        # Page components
│   │   └── routes/       # Route configuration
│   └── README.md         # Frontend documentation
│
├── apk/                   # Flutter Mobile App
│   ├── lib/              # Dart source code
│   └── README.md         # Mobile app documentation
│
├── docs/                  # Documentation
│   ├── blueprint/        # Architecture & design
│   ├── dev/             # Development plans
│   └── qa/              # Testing documentation
│
└── README.md             # This file
```

---

## 📚 Documentation

### Getting Started
- [Quick Start Guide](QUICK_START.md) - Get up and running in 5 minutes
- [Installation Steps](INSTALLATION_STEPS.md) - Detailed installation guide
- [Project Complete](PROJECT_COMPLETE.md) - Complete project overview

### API Documentation
- [API Setup Guide](api/API_SETUP_GUIDE.md) - Backend setup instructions
- [API Endpoints](docs/blueprint/api-endpoints.md) - Complete API reference
- [Architecture](docs/blueprint/architecture.md) - System architecture
- [Database Schema](docs/blueprint/database.md) - Database structure

### Frontend Documentation
- [Frontend Setup](frontend/SETUP.md) - Dashboard setup instructions
- [Development Plan](docs/dev/ADMIN_DASHBOARD_PLAN.md) - Development roadmap
- [Project Summary](frontend/PROJECT_SUMMARY.md) - Feature summary

### Testing
- [Test Credentials](docs/qa/CREDENTIALS.md) - Test user accounts
- [API Testing Status](docs/qa/TESTING_STATUS.md) - API test results
- [APK Testing Status](docs/qa/APK_QA_STATUS.md) - Mobile app test results

---

## 📸 Screenshots

### Admin Dashboard
![Dashboard Overview](docs/screenshots/dashboard.png)
*Real-time statistics and platform metrics*

![User Management](docs/screenshots/users.png)
*User management with suspend/ban capabilities*

![Analytics](docs/screenshots/analytics.png)
*Comprehensive analytics and insights*

---

## 🔌 API Endpoints

### Authentication
```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
```

### Admin
```
GET    /api/v1/admin/users
GET    /api/v1/admin/users/{id}
POST   /api/v1/admin/users/{id}/suspend
POST   /api/v1/admin/users/{id}/ban
GET    /api/v1/admin/reports
GET    /api/v1/admin/analytics/overview
```

**Full API Documentation:** [docs/blueprint/api-endpoints.md](docs/blueprint/api-endpoints.md)

---

## 🧪 Testing

### Backend Tests
```bash
cd api
php artisan test
```

### Frontend Tests
```bash
cd frontend
npm test
```

### Mobile Tests
```bash
cd apk
flutter test
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and development process.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Laravel Framework
- React & TypeScript
- Flutter Framework
- shadcn/ui Components
- All open-source contributors

---

## 📞 Support

- **Documentation:** Check the [docs](docs/) folder
- **Issues:** [GitHub Issues](https://github.com/yourusername/banitalk/issues)
- **Email:** support@banitalk.app

---

## 🗺️ Roadmap

- [x] Backend API (Phase 1-15)
- [x] Admin Dashboard (Phase 1-9)
- [x] Mobile App (Phase 1-9)
- [ ] Production Deployment
- [ ] Performance Optimization
- [ ] Advanced Analytics
- [ ] Multi-language Support
- [ ] Mobile App Store Release

---

## 📊 Project Status

- **API:** ✅ Complete (150+ endpoints)
- **Admin Dashboard:** ✅ Complete (9/10 phases)
- **Mobile App:** ✅ Complete (9/10 phases)
- **Documentation:** ✅ Complete
- **Testing:** ✅ 200+ tests passing

---

**Made with ❤️ by the BaniTalk Team**

> "Breaking language barriers, one conversation at a time."

*Last Updated: March 1, 2026*
