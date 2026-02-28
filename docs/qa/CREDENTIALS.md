# 🔑 BaniTalk Test Credentials

> **Test User Accounts for QA Testing**
> **Environment:** Development/Staging
> **Last Updated:** February 28, 2026

---

## 👥 Test Users

### User 1: Sarah Johnson (Standard User)
```
Name:     Sarah Johnson
Username: sarah_j
Email:    sarah.johnson@test.com
Password: TestPass123!
Role:     user
Status:   active
Language: English (Native), Spanish (Learning)
Coins:    500
```

**Profile Details:**
- Bio: "Language enthusiast learning Spanish. Love music and travel!"
- Country: United States
- Interests: Music, Travel, Food, Movies
- Joined: 2026-02-28

---

### User 2: Carlos Rodriguez (Spanish Speaker)
```
Name:     Carlos Rodriguez
Username: carlos_r
Email:    carlos.rodriguez@test.com
Password: TestPass123!
Role:     user
Status:   active
Language: Spanish (Native), English (Learning)
Coins:    750
```

**Profile Details:**
- Bio: "Hola! Practicing English and looking for language partners."
- Country: Spain
- Interests: Sports, Technology, Gaming
- Joined: 2026-02-28

---

### User 3: Emma Chen (Premium User)
```
Name:     Emma Chen
Username: emma_chen
Email:    emma.chen@test.com
Password: TestPass123!
Role:     user
Status:   active
Language: Chinese (Native), English (Learning), Japanese (Learning)
Coins:    2000
VIP:      true
```

**Profile Details:**
- Bio: "Polyglot in training! Native Chinese speaker, learning English and Japanese."
- Country: China
- Interests: Art, Literature, Music, Photography
- Joined: 2026-02-28
- VIP Status: Premium Member

---

### User 4: Ahmed Hassan (New User)
```
Name:     Ahmed Hassan
Username: ahmed_h
Email:    ahmed.hassan@test.com
Password: TestPass123!
Role:     user
Status:   active
Language: Arabic (Native), French (Learning)
Coins:    100
```

**Profile Details:**
- Bio: "Just joined! Excited to practice French with native speakers."
- Country: Egypt
- Interests: History, Culture, Travel
- Joined: 2026-02-28
- Experience: Beginner

---

### User 5: Maria Silva (Content Creator)
```
Name:     Maria Silva
Username: maria_silva
Email:    maria.silva@test.com
Password: TestPass123!
Role:     user
Status:   active
Language: Portuguese (Native), English (Native), German (Learning)
Coins:    1200
```

**Profile Details:**
- Bio: "Bilingual PT/EN speaker sharing my language journey. Teacher by day, learner by night!"
- Country: Brazil
- Interests: Education, Teaching, Music, Dance
- Joined: 2026-02-28
- Followers: 150+

---

## 🔧 Admin Users (For Testing)

### Admin User
```
Name:     Test Admin
Username: admin_test
Email:    admin@test.com
Password: AdminPass123!
Role:     admin
Status:   active
Permissions: User management, Report review, Content moderation
```

### Super Admin User
```
Name:     Super Admin
Username: super_admin
Email:    superadmin@test.com
Password: SuperAdmin123!
Role:     super_admin
Status:   active
Permissions: All permissions including admin creation
```

---

## 📋 Test Scenarios by User

### Sarah Johnson (User 1)
**Use Cases:**
- Standard messaging flow
- Voice call testing (English-Spanish exchange)
- Social feed interactions
- Gift sending/receiving
- Profile editing

**Test Data:**
- Conversations: 5 active
- Posts: 3 moments shared
- Following: 10 users
- Followers: 8 users

---

### Carlos Rodriguez (User 2)
**Use Cases:**
- Language matching (Spanish speaker)
- Voice room participation
- Pronunciation practice (SL module)
- Video calls

**Test Data:**
- Conversations: 3 active
- Voice rooms joined: 12
- SL scores: 5 tongue twisters completed

---

### Emma Chen (User 3)
**Use Cases:**
- Premium features testing
- Multiple language learning
- High coin balance transactions
- VIP badge display
- Advanced matching algorithm

**Test Data:**
- Conversations: 10 active
- Coins: 2000
- VIP: Yes
- Gifts received: 25+

---

### Ahmed Hassan (User 4)
**Use Cases:**
- Onboarding flow testing
- New user experience
- First conversation
- Initial coin purchase
- Beginner language level

**Test Data:**
- Conversations: 1 active
- Coins: 100
- New user: Yes
- Onboarding: Completed

---

### Maria Silva (User 5)
**Use Cases:**
- Content creation testing
- Social feed posts
- Follower interactions
- Teaching/learning mode
- Matching as bilingual user

**Test Data:**
- Posts: 15 moments
- Followers: 150
- Following: 45
- Voice rooms hosted: 8

---

## 🚀 Quick Login Commands

### API Testing (cURL)

**Login Sarah:**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "sarah.johnson@test.com",
    "password": "TestPass123!"
  }'
```

**Login Carlos:**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "carlos.rodriguez@test.com",
    "password": "TestPass123!"
  }'
```

**Login Emma (Premium):**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "emma.chen@test.com",
    "password": "TestPass123!"
  }'
```

**Login Ahmed (New User):**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ahmed.hassan@test.com",
    "password": "TestPass123!"
  }'
```

**Login Maria (Content Creator):**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "maria.silva@test.com",
    "password": "TestPass123!"
  }'
```

**Login Admin:**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@test.com",
    "password": "AdminPass123!"
  }'
```

---

### APK Testing (Manual Login)

Use these credentials in the login screen:

| User | Email | Password |
|------|-------|----------|
| Sarah | sarah.johnson@test.com | TestPass123! |
| Carlos | carlos.rodriguez@test.com | TestPass123! |
| Emma | emma.chen@test.com | TestPass123! |
| Ahmed | ahmed.hassan@test.com | TestPass123! |
| Maria | maria.silva@test.com | TestPass123! |

---

## 🔄 Seeder Commands

To add these users to your database:

```bash
# Run specific seeder
cd api
php artisan db:seed --class=TestUsersSeeder

# Or refresh with seeders
php artisan migrate:fresh --seed
```

---

## ⚠️ Security Notice

> **WARNING:** These are test credentials for development/staging only!
> 
> - Do NOT use in production
> - Do NOT use real personal information
> - Rotate passwords regularly
> - Disable test accounts in production

---

## 📊 Test Data Relationships

```
Sarah (EN) ←→ Carlos (ES)    [Language Exchange]
Emma (CN) → Premium Features  [VIP Testing]
Ahmed (AR) → New User Flow    [Onboarding Testing]
Maria (PT) → Social Feed       [Content Testing]
```

---

## 📝 Additional Test Accounts

### Group Chat Test
Create a conversation with all 5 users for group chat testing.

### Matching Test
Test compatibility scoring between:
- Sarah ↔ Carlos (Language match)
- Emma ↔ Ahmed (Learning partners)
- Maria ↔ All (Popular user)

### Gift Economy Test
- Emma sends gifts (high balance)
- Ahmed receives gifts (new user)
- Carlos exchanges gifts

---

## 🔗 Related Documentation

- [Testing Plan](./BANITALK_TESTING_PLAN.md) — Full test scenarios
- [APK QA Status](./APK_QA_STATUS.md) — APK testing results
- [API Testing Status](./TESTING_STATUS.md) — API endpoint tests
- [Setup Guide](../../api/README.md) — API installation

---

*Last Updated: February 28, 2026*
*Maintained by: QA Team*
