# �️ BaniTalk — Language Learning & Cultural Exchange Platform

> **Connect. Learn. Share. Grow.**
> A comprehensive language learning and cultural exchange platform connecting people worldwide through real-time communication, AI-powered speech learning, and social features.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.27+-blue.svg)](https://flutter.dev)
[![Laravel Version](https://img.shields.io/badge/Laravel-11.x-red.svg)](https://laravel.com)
[![API Status](https://img.shields.io/badge/API-v1-green.svg)](./api/README.md)
[![APK Status](https://img.shields.io/badge/APK-9%2F10%20Phases-orange.svg)](./docs/qa/APK_QA_STATUS.md)

---

## � Project Structure

```
banitalk/
├── 📱 apk/                    # Flutter Mobile Application
│   ├── lib/features/          # 11 Feature Modules (100+ files)
│   ├── android/               # Android Platform Code
│   ├── ios/                   # iOS Platform Code
│   └── README.md              # APK Documentation ⬇️
│
├── 🔧 api/                    # Laravel Backend API
│   ├── app/Http/Controllers/  # API Controllers
│   ├── database/migrations/   # Database Schema
│   ├── routes/api.php         # API Routes
│   └── README.md              # API Documentation ⬇️
│
├── 📚 docs/                   # Documentation
│   ├── dev/                   # Development Plans
│   │   ├── apk-dev.md         # APK Development Roadmap ⬇️
│   │   └── api-dev.md         # API Development Status ⬇️
│   ├── qa/                    # QA & Testing
│   │   ├── APK_QA_STATUS.md   # APK Testing Status ⬇️
│   │   └── TESTING_STATUS.md  # API Testing Status ⬇️
│   └── blueprint/             # Architecture Blueprints
│
└── README.md                  # This file
```

---

## 📚 Quick Links

| Documentation | Status | Description |
|--------------|--------|-------------|
| [📱 APK Documentation](./apk/README.md) | 9/10 Phases ✅ | Flutter app setup & features |
| [🔧 API Documentation](./api/README.md) | v1 Complete ✅ | Laravel backend endpoints |
| [📋 APK Dev Plan](./docs/dev/apk-dev.md) | Updated 2026-02-28 | Development roadmap |
| [📋 API Dev Plan](./docs/dev/api-dev.md) | Updated 2026-02-28 | API development status |
| [🧪 APK QA Status](./docs/qa/APK_QA_STATUS.md) | 100+ Tests ✅ | APK testing results |
| [🧪 API QA Status](./docs/qa/TESTING_STATUS.md) | 200+ Tests ✅ | API endpoint testing |
| [🏗️ Architecture](./docs/blueprint/) | Complete | System architecture docs |

---

## ✨ Features

### Core Features
- 🔐 **Authentication** — Secure login with Sanctum, Google/Apple OAuth
- 💬 **Real-time Messaging** — WebSocket-powered chat with reactions
- 📞 **Voice & Video Calls** — WebRTC P2P calling
- 🎙️ **Voice Rooms** — Community audio rooms with Agora SDK
- � **Social Feed** — Share moments with photos, videos, comments
- 🤖 **Speech Learning** — AI-powered pronunciation coach
- 🎁 **Virtual Economy** — Gifts, coins, in-app purchases
- 💕 **Partner Matching** — Discovery deck with compatibility scoring
- � **Push Notifications** — Firebase messaging

---

## 🚀 Quick Start

### Prerequisites
- Flutter 3.27+ | Dart 3.0+
- PHP 8.2+ | Composer 2.x
- Node.js 18+
- MySQL 8.0+ or PostgreSQL 14+
- Redis (optional, for caching)

### 1. Clone & Setup
```bash
git clone https://github.com/yourorg/banitalk.git
cd banitalk
```

### 2. Backend Setup
```bash
cd api
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```
📖 [Full API Setup Guide](./api/README.md)

### 3. Mobile App Setup
```bash
cd apk
flutter pub get
flutter run
```
📖 [Full APK Setup Guide](./apk/README.md)

---

## 📱 APK Modules (11 Features)

| Module | Files | Status | Description |
|--------|-------|--------|-------------|
| Auth | 8 | ✅ | Login, Register, Onboarding |
| Chat | 11 | ✅ | Real-time messaging |
| Call | 8 | ✅ | WebRTC voice/video |
| Social Feed | 24 | ✅ | Moments, posts, comments |
| Voice Rooms | - | ✅ | Agora audio rooms |
| Speech Learning | 12 | ✅ | AI pronunciation coach |
| Gifts | 11 | ✅ | Virtual economy |
| Matching | 8 | ✅ | Partner discovery |
| Notifications | 6 | ✅ | Push notifications |
| Home | 1 | ✅ | Dashboard with modern UI |
| Profile | 11 | ✅ | User profiles |

**Total: 100+ Dart files | 25+ dependencies**

---

## 🔧 API Endpoints (v1)

### Core Endpoints
```
# Auth
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/logout

# Users
GET    /api/v1/users/me
GET    /api/v1/users/search

# Chat
GET    /api/v1/chat/conversations
POST   /api/v1/chat/messages

# Calls
POST   /api/v1/calls/initiate
POST   /api/v1/calls/{id}/answer

# Voice Rooms
GET    /api/v1/rooms
POST   /api/v1/rooms/{id}/join

# Social
GET    /api/v1/posts
POST   /api/v1/posts/{id}/like

# Speech Learning
GET    /api/v1/sl/tongue-twisters
POST   /api/v1/sl/analyze-pronunciation

# Gifts
GET    /api/v1/gifts
POST   /api/v1/gifts/send
GET    /api/v1/gifts/wallet

# Matching
GET    /api/v1/matching/discover
POST   /api/v1/matching/like
GET    /api/v1/matching/matches
```

📖 [Full API Documentation](./api/README.md) | [API Testing](./docs/qa/TESTING_STATUS.md)

---

## 📊 Development Status

### APK Phases (9/10 Complete)

| Phase | Feature | Status |
|-------|---------|--------|
| 0 | Base Architecture | ✅ |
| 1 | Authentication | ✅ |
| 2 | Profiles & Discovery | ✅ |
| 3 | Messaging | ✅ |
| 4 | Calls (WebRTC) | ✅ |
| 5 | Voice Rooms | ✅ |
| 6 | Social Feed | ✅ |
| 7 | Speech Learning | ✅ |
| 8 | Virtual Economy | ✅ |
| 9 | Matching & Notifications | ✅ |
| 10 | Production QA | ⏳ |

📊 [Detailed APK QA Report](./docs/qa/APK_QA_STATUS.md)

---

## 🎨 Modern UI Features

- 🌙 **Dark Theme** — `#0F1419` background
- ✨ **Glassmorphism** — Backdrop blur cards
- 🎭 **Animations** — 3D hover, pulsing badges, gradients
- 🎯 **Floating Navigation** — Glass effect with animated selection
- 🌊 **Animated Gradients** — Dynamic background colors

---

## 🧪 Testing

```bash
# API Tests
cd api && php artisan test

# APK Tests  
cd apk && flutter test
```

- [API Testing Status](./docs/qa/TESTING_STATUS.md) — 200+ tests
- [APK Testing Status](./docs/qa/APK_QA_STATUS.md) — 100+ tests

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📄 License

MIT License — see [LICENSE](LICENSE)

---

**Made with ❤️ by the BaniTalk Team**

> "Breaking language barriers, one conversation at a time."

*Last Updated: February 28, 2026*
