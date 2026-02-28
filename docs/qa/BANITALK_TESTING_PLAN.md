# 🧪 BaniTalk — Complete QA Testing Plan

> **Comprehensive Testing Strategy for APK & API**
> **Version:** 1.0
> **Last Updated:** February 28, 2026
> **Status:** Phase 10 - Production QA

---

## 📋 Testing Overview

### Scope
| Component | Coverage | Priority |
|-----------|----------|----------|
| **API (Backend)** | 200+ endpoints | High |
| **APK (Mobile)** | 11 feature modules | High |
| **Integration** | API ↔ APK | High |
| **E2E** | Full user flows | Medium |
| **Performance** | Load & stress | Medium |
| **Security** | Auth & data | High |

### Testing Types
1. **Unit Testing** — Individual component testing
2. **Integration Testing** — Module interaction testing
3. **API Testing** — Endpoint validation
4. **UI/UX Testing** — Interface & experience
5. **Performance Testing** — Speed & responsiveness
6. **Security Testing** — Vulnerability assessment
7. **Compatibility Testing** — Device & OS variations
8. **Regression Testing** — Post-change validation

---

## 🔧 API Testing Plan

### Test Environment
```
Base URL: http://localhost:8000/api/v1
Test Database: banitalk_test
Test User: test@banitalk.com / TestPass123!
```

### Phase 0: Foundation Testing

| Test ID | Test Name | Method | Endpoint | Expected | Priority |
|---------|-----------|--------|----------|----------|----------|
| API-0.1 | Health Check | GET | `/up` | 200 OK | ✅ High |
| API-0.2 | Migrations | — | `migrate` | Success | ✅ High |
| API-0.3 | Seeders | — | `db:seed` | Success | ✅ High |
| API-0.4 | CORS Headers | OPTIONS | `/*` | Headers present | ✅ High |
| API-0.5 | Rate Limiting | GET | `/users/me` | 429 after limit | ✅ High |

### Phase 1: Authentication Testing

| Test ID | Test Name | Method | Payload | Expected | Status |
|---------|-----------|--------|---------|----------|--------|
| AUTH-1.1 | Register Success | POST | `{email,password,name}` | 201 + Token | ⬜ |
| AUTH-1.2 | Register Duplicate | POST | Same email | 422 Error | ⬜ |
| AUTH-1.3 | Login Success | POST | `{email,password}` | 200 + Token | ⬜ |
| AUTH-1.4 | Login Wrong Pass | POST | Wrong password | 401 Unauthorized | ⬜ |
| AUTH-1.5 | Login Non-existent | POST | Fake email | 404 Not Found | ⬜ |
| AUTH-1.6 | Logout | POST | Bearer token | 200 Success | ⬜ |
| AUTH-1.7 | Token Refresh | POST | Refresh token | New access token | ⬜ |
| AUTH-1.8 | Expired Token | GET | Expired bearer | 401 Unauthorized | ⬜ |
| AUTH-1.9 | Invalid Token | GET | Malformed token | 401 Unauthorized | ⬜ |
| AUTH-1.10 | Missing Token | GET | No header | 401 Unauthorized | ⬜ |
| AUTH-1.11 | Password Reset | POST | `{email}` | 200 Email sent | ⬜ |
| AUTH-1.12 | Password Update | PUT | `{old,new}` | 200 Success | ⬜ |

### Phase 2: User & Profile Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| USER-2.1 | Get Current User | GET | `/users/me` | 200 + User data | ⬜ |
| USER-2.2 | Update User | PUT | `/users/me` | 200 Updated | ⬜ |
| USER-2.3 | Get User by ID | GET | `/users/{id}` | 200 User data | ⬜ |
| USER-2.4 | Search Users | GET | `/users/search?q=term` | 200 Results | ⬜ |
| USER-2.5 | Search Filters | GET | `/users/search?country=US` | Filtered results | ⬜ |
| USER-2.6 | Popular Searches | GET | `/users/popular-searches` | 200 List | ⬜ |
| PROFILE-2.7 | Get My Profile | GET | `/profiles/me` | 200 Profile | ⬜ |
| PROFILE-2.8 | Update Profile | PUT | `/profiles/me` | 200 Updated | ⬜ |
| PROFILE-2.9 | Upload Avatar | POST | `/profiles/me/photo` | 200 + URL | ⬜ |
| PROFILE-2.10 | Update Languages | PUT | `/profiles/me/languages` | 200 Updated | ⬜ |
| PROFILE-2.11 | Get Other Profile | GET | `/profiles/{id}` | 200 Profile | ⬜ |
| PROFILE-2.12 | Blocked User Check | GET | `/profiles/{blocked_id}` | 403 Forbidden | ⬜ |

### Phase 3: Social Features Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| SOCIAL-3.1 | Follow User | POST | `/users/{id}/follow` | 200 Success | ⬜ |
| SOCIAL-3.2 | Follow Self | POST | `/users/self/follow` | 422 Error | ⬜ |
| SOCIAL-3.3 | Follow Again | POST | Already following | 422 Error | ⬜ |
| SOCIAL-3.4 | Unfollow User | DELETE | `/users/{id}/follow` | 200 Success | ⬜ |
| SOCIAL-3.5 | Get Followers | GET | `/users/{id}/followers` | 200 List | ⬜ |
| SOCIAL-3.6 | Get Following | GET | `/users/{id}/following` | 200 List | ⬜ |
| SOCIAL-3.7 | Block User | POST | `/users/{id}/block` | 200 Success | ⬜ |
| SOCIAL-3.8 | Block Self | POST | `/users/self/block` | 422 Error | ⬜ |
| SOCIAL-3.9 | Block Removes Follow | — | Check follow removed | No follow | ⬜ |
| SOCIAL-3.10 | Unblock User | DELETE | `/users/{id}/block` | 200 Success | ⬜ |
| SOCIAL-3.11 | Get Blocked List | GET | `/users/blocked` | 200 List | ⬜ |
| SOCIAL-3.12 | Blocked User Access | GET | `/profiles/{id}` | 403 Forbidden | ⬜ |

### Phase 4: Chat System Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| CHAT-4.1 | List Conversations | GET | `/chat/conversations` | 200 List | ⬜ |
| CHAT-4.2 | Create Conversation | POST | `/chat/conversations` | 201 Created | ⬜ |
| CHAT-4.3 | Create Duplicate | POST | Same users | Returns existing | ⬜ |
| CHAT-4.4 | Blocked User Chat | POST | With blocked user | 403 Forbidden | ⬜ |
| CHAT-4.5 | View Conversation | GET | `/chat/conversations/{id}` | 200 Details | ⬜ |
| CHAT-4.6 | Send Typing | POST | `/chat/conversations/{id}/typing` | 200 Broadcast | ⬜ |
| CHAT-4.7 | List Messages | GET | `/chat/conversations/{id}/messages` | 200 Paginated | ⬜ |
| CHAT-4.8 | Send Text Message | POST | `/chat/conversations/{id}/messages` | 201 Created | ⬜ |
| CHAT-4.9 | Send Empty Message | POST | Empty content | 422 Error | ⬜ |
| CHAT-4.10 | Send Long Message | POST | >5000 chars | 422 Error | ⬜ |
| CHAT-4.11 | Delete Message | DELETE | `/chat/messages/{id}` | 200 Soft delete | ⬜ |
| CHAT-4.12 | Delete Others Msg | DELETE | Not owned | 403 Forbidden | ⬜ |
| CHAT-4.13 | Mark as Read | POST | `/chat/conversations/{id}/read` | 200 Success | ⬜ |
| CHAT-4.14 | Send Media | POST | `/chat/conversations/{id}/media` | 201 + URL | ⬜ |
| CHAT-4.15 | Invalid Media Type | POST | Wrong mime type | 422 Error | ⬜ |
| CHAT-4.16 | Media Too Large | POST | >10MB | 413 Error | ⬜ |
| CHAT-4.17 | Add Reaction | POST | `/chat/messages/{id}/reactions` | 201 Created | ⬜ |
| CHAT-4.18 | Remove Reaction | DELETE | `/chat/messages/{id}/reactions/{emoji}` | 200 Success | ⬜ |

### Phase 5: Voice & Video Calls Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| CALL-5.1 | Initiate Voice Call | POST | `/calls/initiate` | 201 + Session | ⬜ |
| CALL-5.2 | Initiate Video Call | POST | `/video/initiate` | 201 + Session | ⬜ |
| CALL-5.3 | Call Blocked User | POST | To blocked user | 403 Forbidden | ⬜ |
| CALL-5.4 | Answer Call | POST | `/calls/{id}/answer` | 200 Connected | ⬜ |
| CALL-5.5 | Decline Call | POST | `/calls/{id}/decline` | 200 Declined | ⬜ |
| CALL-5.6 | End Call | POST | `/calls/{id}/end` | 200 Ended | ⬜ |
| CALL-5.7 | Send ICE Candidate | POST | `/calls/{id}/ice-candidate` | 200 Relayed | ⬜ |
| CALL-5.8 | Toggle Video | POST | `/video/{id}/toggle-video` | 200 Toggled | ⬜ |
| CALL-5.9 | Call History | GET | `/calls/history` | 200 List | ⬜ |
| CALL-5.10 | Video History | GET | `/video/history` | 200 List | ⬜ |

### Phase 6: Voice Rooms Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| ROOM-6.1 | List Rooms | GET | `/rooms` | 200 Paginated | ⬜ |
| ROOM-6.2 | List With Filter | GET | `/rooms?language=en` | Filtered | ⬜ |
| ROOM-6.3 | Create Room | POST | `/rooms` | 201 Created | ⬜ |
| ROOM-6.4 | Create No Title | POST | Missing title | 422 Error | ⬜ |
| ROOM-6.5 | View Room | GET | `/rooms/{id}` | 200 Details | ⬜ |
| ROOM-6.6 | Update Room | PUT | `/rooms/{id}` | 200 Updated | ⬜ |
| ROOM-6.7 | Delete Room | DELETE | `/rooms/{id}` | 200 Deleted | ⬜ |
| ROOM-6.8 | Delete Not Owner | DELETE | Others room | 403 Forbidden | ⬜ |
| ROOM-6.9 | Join Room | POST | `/rooms/{id}/join` | 200 Joined | ⬜ |
| ROOM-6.10 | Join Blocked Room | POST | Host blocked you | 403 Forbidden | ⬜ |
| ROOM-6.11 | Leave Room | POST | `/rooms/{id}/leave` | 200 Left | ⬜ |
| ROOM-6.12 | Request to Speak | POST | `/rooms/{id}/speak` | 200 Requested | ⬜ |
| ROOM-6.13 | Promote Speaker | POST | `/rooms/{id}/speakers/{userId}` | 200 Promoted | ⬜ |
| ROOM-6.14 | Demote Speaker | DELETE | `/rooms/{id}/speakers/{userId}` | 200 Demoted | ⬜ |
| ROOM-6.15 | Kick User | POST | `/rooms/{id}/kick/{userId}` | 200 Kicked | ⬜ |
| ROOM-6.16 | Room History | GET | `/rooms/history` | 200 List | ⬜ |
| ROOM-6.17 | Send Reaction | POST | `/rooms/{id}/reactions` | 200 Broadcast | ⬜ |

### Phase 7: Social Feed Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| FEED-7.1 | List Posts | GET | `/posts` | 200 Paginated | ⬜ |
| FEED-7.2 | List With Filter | GET | `/posts?user_id=1` | Filtered | ⬜ |
| FEED-7.3 | Create Post | POST | `/posts` | 201 Created | ⬜ |
| FEED-7.4 | Create Empty | POST | No content | 422 Error | ⬜ |
| FEED-7.5 | Create Too Long | POST | >5000 chars | 422 Error | ⬜ |
| FEED-7.6 | View Post | GET | `/posts/{id}` | 200 Details | ⬜ |
| FEED-7.7 | Update Post | PUT | `/posts/{id}` | 200 Updated | ⬜ |
| FEED-7.8 | Update Others | PUT | Not owned | 403 Forbidden | ⬜ |
| FEED-7.9 | Delete Post | DELETE | `/posts/{id}` | 200 Deleted | ⬜ |
| FEED-7.10 | Delete Others | DELETE | Not owned | 403 Forbidden | ⬜ |
| FEED-7.11 | Upload Media | POST | `/posts/{id}/media` | 200 + URLs | ⬜ |
| FEED-7.12 | Like Post | POST | `/posts/{id}/like` | 200 Liked | ⬜ |
| FEED-7.13 | Unlike Post | DELETE | `/posts/{id}/like` | 200 Unliked | ⬜ |
| FEED-7.14 | Get Likers | GET | `/posts/{id}/likes` | 200 List | ⬜ |
| FEED-7.15 | Save Post | POST | `/posts/{id}/save` | 200 Saved | ⬜ |
| FEED-7.16 | Unsave Post | DELETE | `/posts/{id}/save` | 200 Unsaved | ⬜ |
| FEED-7.17 | Get Saved | GET | `/posts/saved` | 200 List | ⬜ |
| FEED-7.18 | List Comments | GET | `/posts/{id}/comments` | 200 Threaded | ⬜ |
| FEED-7.19 | Add Comment | POST | `/posts/{id}/comments` | 201 Created | ⬜ |
| FEED-7.20 | Delete Comment | DELETE | `/comments/{id}` | 200 Deleted | ⬜ |
| FEED-7.21 | Delete Others Cmt | DELETE | Not owned | 403 Forbidden | ⬜ |

### Phase 8: Speech Learning Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| SL-8.1 | List Tongue Twisters | GET | `/sl/tongue-twisters` | 200 List | ⬜ |
| SL-8.2 | List With Level | GET | `/sl/tongue-twisters?level=easy` | Filtered | ⬜ |
| SL-8.3 | Get Twister | GET | `/sl/tongue-twisters/{id}` | 200 Details | ⬜ |
| SL-8.4 | Analyze Pronunciation | POST | `/sl/analyze-pronunciation` | 200 Score | ⬜ |
| SL-8.5 | Analyze Empty | POST | No audio | 422 Error | ⬜ |
| SL-8.6 | Get Leaderboard | GET | `/sl/leaderboard` | 200 Ranked | ⬜ |
| SL-8.7 | Get Personal Best | GET | `/sl/leaderboard/me` | 200 Scores | ⬜ |
| SL-8.8 | Unlock Twister | POST | `/sl/tongue-twisters/{id}/unlock` | 200 Unlocked | ⬜ |
| SL-8.9 | Unlock No Coins | POST | Insufficient | 400 Error | ⬜ |
| SL-8.10 | Save Score | POST | `/sl/scores` | 201 Saved | ⬜ |

### Phase 9: Gifts & Economy Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| GIFT-9.1 | List Gifts | GET | `/gifts` | 200 Catalog | ⬜ |
| GIFT-9.2 | List By Category | GET | `/gifts?category=cultural` | Filtered | ⬜ |
| GIFT-9.3 | Get Gift | GET | `/gifts/{id}` | 200 Details | ⬜ |
| GIFT-9.4 | Send Gift | POST | `/gifts/send` | 200 Sent | ⬜ |
| GIFT-9.5 | Send No Coins | POST | Insufficient | 400 Error | ⬜ |
| GIFT-9.6 | Send to Self | POST | Self recipient | 400 Error | ⬜ |
| GIFT-9.7 | Get Transactions | GET | `/gifts/transactions` | 200 List | ⬜ |
| GIFT-9.8 | Get Wallet | GET | `/gifts/wallet` | 200 Balance | ⬜ |
| GIFT-9.9 | Get Coin Packages | GET | `/gifts/coins/packages` | 200 List | ⬜ |
| GIFT-9.10 | Purchase Coins | POST | `/gifts/coins/purchase` | 200 Added | ⬜ |
| GIFT-9.11 | Invalid Package | POST | Wrong package_id | 400 Error | ⬜ |

### Phase 10: Matching Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| MATCH-10.1 | Discover Users | GET | `/matching/discover` | 200 List | ⬜ |
| MATCH-10.2 | Discover Filtered | GET | `/matching/discover?language=en` | Filtered | ⬜ |
| MATCH-10.3 | Discover With Interests | GET | `/matching/discover?interests=music` | Filtered | ⬜ |
| MATCH-10.4 | Like User | POST | `/matching/like` | 200 Liked | ⬜ |
| MATCH-10.5 | Like Self | POST | Self user_id | 400 Error | ⬜ |
| MATCH-10.6 | Like Creates Match | POST | Mutual like | 200 + Match | ⬜ |
| MATCH-10.7 | Pass User | POST | `/matching/pass` | 200 Passed | ⬜ |
| MATCH-10.8 | Super Like | POST | `/matching/super-like` | 200 + Match | ⬜ |
| MATCH-10.9 | Undo Swipe | POST | `/matching/undo` | 200 Undone | ⬜ |
| MATCH-10.10 | Get Matches | GET | `/matching/matches` | 200 List | ⬜ |
| MATCH-10.11 | Get Leaderboard | GET | `/matching/leaderboard` | 200 Ranked | ⬜ |

### Phase 11: Admin Testing

| Test ID | Test Name | Method | Endpoint | Expected | Status |
|---------|-----------|--------|----------|----------|--------|
| ADMIN-11.1 | List Users | GET | `/admin/users` | 200 Paginated | ⬜ |
| ADMIN-11.2 | Get User Detail | GET | `/admin/users/{id}` | 200 Details | ⬜ |
| ADMIN-11.3 | Suspend User | POST | `/admin/users/{id}/suspend` | 200 Suspended | ⬜ |
| ADMIN-11.4 | Restore User | POST | `/admin/users/{id}/restore` | 200 Restored | ⬜ |
| ADMIN-11.5 | Warn User | POST | `/admin/users/{id}/warn` | 200 Warned | ⬜ |
| ADMIN-11.6 | List Reports | GET | `/admin/reports` | 200 Paginated | ⬜ |
| ADMIN-11.7 | Resolve Report | POST | `/admin/reports/{id}/resolve` | 200 Resolved | ⬜ |
| ADMIN-11.8 | User Analytics | GET | `/admin/analytics/users` | 200 Stats | ⬜ |
| ADMIN-11.9 | Calls Analytics | GET | `/admin/analytics/calls` | 200 Stats | ⬜ |
| ADMIN-11.10 | Ban User (Super) | POST | `/admin/users/{id}/ban` | 200 Banned | ⬜ |
| ADMIN-11.11 | List Admins | GET | `/admin/admins` | 200 List | ⬜ |
| ADMIN-11.12 | Create Admin | POST | `/admin/admins` | 201 Created | ⬜ |

---

## 📱 APK Testing Plan

### Test Environment
```
Device: Android Emulator / Physical Device
OS: Android 12+ / iOS 15+
Screen: Multiple sizes (small, normal, large, xlarge)
Network: WiFi, 4G, 3G, Offline
```

### Phase 0: App Launch & UI

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| APK-0.1 | App Launch | Tap app icon | Splash screen → Home | ⬜ |
| APK-0.2 | Cold Start | Kill & restart | Launch < 3 seconds | ⬜ |
| APK-0.3 | Hot Start | Background & return | Resume < 1 second | ⬜ |
| APK-0.4 | Theme Toggle | Switch dark/light | All screens update | ⬜ |
| APK-0.5 | Rotation | Rotate device | Layout adjusts | ⬜ |
| APK-0.6 | Bottom Navigation | Tap all 8 tabs | Each tab loads | ⬜ |
| APK-0.7 | Nav Selection | Select current tab | Stay on page | ⬜ |
| APK-0.8 | Back Button | Press back | Proper navigation | ⬜ |

### Phase 1: Authentication Flow

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| AUTH-A.1 | Login Screen UI | Open login | All elements visible | ⬜ |
| AUTH-A.2 | Valid Login | Enter credentials | Navigate to home | ⬜ |
| AUTH-A.3 | Invalid Login | Wrong password | Error message | ⬜ |
| AUTH-A.4 | Empty Fields | Submit empty | Validation errors | ⬜ |
| AUTH-A.5 | Register Screen | Navigate to register | Form displayed | ⬜ |
| AUTH-A.6 | Valid Register | Fill all fields | Success + auto-login | ⬜ |
| AUTH-A.7 | Duplicate Email | Used email | Error message | ⬜ |
| AUTH-A.8 | Password Match | Mismatch confirm | Validation error | ⬜ |
| AUTH-A.9 | Google Sign-In | Tap Google button | OAuth flow | ⬜ |
| AUTH-A.10 | Apple Sign-In | Tap Apple button | OAuth flow | ⬜ |
| AUTH-A.11 | Logout | Tap logout | Return to login | ⬜ |
| AUTH-A.12 | Session Expiry | Wait for token expire | Re-login prompt | ⬜ |

### Phase 2: Onboarding Flow

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| ONBOARD-A.1 | Step 1 - Identity | Avatar upload | Image cropped & saved | ⬜ |
| ONBOARD-A.2 | Step 2 - Languages | Select languages | Saved to profile | ⬜ |
| ONBOARD-A.3 | Step 3 - Interests | Select interests | Tags displayed | ⬜ |
| ONBOARD-A.4 | Skip Onboarding | Skip button | Can skip | ⬜ |
| ONBOARD-A.5 | Back Navigation | Go back | Previous step | ⬜ |
| ONBOARD-A.6 | Complete All | Finish all steps | Home screen | ⬜ |

### Phase 3: Home Screen

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| HOME-A.1 | Welcome Card | View home | Gradient card visible | ⬜ |
| HOME-A.2 | Wallet Display | Check balance | Coins shown | ⬜ |
| HOME-A.3 | Quick Actions | Tap Discover | Navigate to search | ⬜ |
| HOME-A.4 | Quick Actions | Tap Match | Navigate to matching | ⬜ |
| HOME-A.5 | Quick Actions | Tap Messages | Navigate to chat | ⬜ |
| HOME-A.6 | Quick Actions | Tap Practice | Navigate to SL | ⬜ |
| HOME-A.7 | Recent Activity | View notifications | Last 3 shown | ⬜ |
| HOME-A.8 | Notification Badge | Receive notification | Badge increments | ⬜ |
| HOME-A.9 | Features Section | Tap Moments | Navigate to feed | ⬜ |
| HOME-A.10 | Features Section | Tap Gifts | Navigate to gifts | ⬜ |

### Phase 4: Profile & Social

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| PROFILE-A.1 | View Profile | Open profile | User info displayed | ⬜ |
| PROFILE-A.2 | Edit Profile | Tap edit | Form opens | ⬜ |
| PROFILE-A.3 | Update Bio | Change bio | Saved successfully | ⬜ |
| PROFILE-A.4 | Change Avatar | Upload new | Avatar updated | ⬜ |
| PROFILE-A.5 | View Stats | Check stats | Followers/following count | ⬜ |
| PROFILE-A.6 | Search Users | Enter query | Results displayed | ⬜ |
| PROFILE-A.7 | Follow User | Tap follow | Button changes | ⬜ |
| PROFILE-A.8 | Unfollow User | Tap unfollow | Button changes | ⬜ |
| PROFILE-A.9 | Block User | Tap block | User blocked | ⬜ |
| PROFILE-A.10 | View Followers | Tap followers | List displayed | ⬜ |

### Phase 5: Chat System

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| CHAT-A.1 | Chat List | Open chat tab | Conversations list | ⬜ |
| CHAT-A.2 | Create Chat | Tap new chat | User selector | ⬜ |
| CHAT-A.3 | Send Message | Type & send | Message appears | ⬜ |
| CHAT-A.4 | Receive Message | Get message | Notification + bubble | ⬜ |
| CHAT-A.5 | Send Image | Attach image | Image sent | ⬜ |
| CHAT-A.6 | Send Voice | Record audio | Audio sent | ⬜ |
| CHAT-A.7 | Emoji Picker | Tap emoji | Picker opens | ⬜ |
| CHAT-A.8 | Message Reaction | Long press | Reactions appear | ⬜ |
| CHAT-A.9 | Delete Message | Delete own | Message removed | ⬜ |
| CHAT-A.10 | Typing Indicator | Other types | Indicator shown | ⬜ |
| CHAT-A.11 | Swipe Archive | Swipe conversation | Archived | ⬜ |
| CHAT-A.12 | Unread Badge | New message | Badge shows count | ⬜ |

### Phase 6: Voice & Video Calls

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| CALL-A.1 | Initiate Voice | Tap call button | Calling screen | ⬜ |
| CALL-A.2 | Initiate Video | Tap video button | Video calling screen | ⬜ |
| CALL-A.3 | Answer Call | Receive call | Answer/decline options | ⬜ |
| CALL-A.4 | Decline Call | Tap decline | Call ended | ⬜ |
| CALL-A.5 | End Call | Tap end | Call ended, summary | ⬜ |
| CALL-A.6 | Mute Call | Tap mute | Audio muted | ⬜ |
| CALL-A.7 | Speaker Mode | Tap speaker | Audio routed | ⬜ |
| CALL-A.8 | Toggle Video | Tap camera | Video on/off | ⬜ |
| CALL-A.9 | Switch Camera | Flip camera | Front/rear toggle | ⬜ |
| CALL-A.10 | Call Quality | Check connection | Clear audio/video | ⬜ |

### Phase 7: Voice Rooms

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| ROOM-A.1 | Room Browser | Open rooms | List of rooms | ⬜ |
| ROOM-A.2 | Filter Rooms | Select filter | Filtered results | ⬜ |
| ROOM-A.3 | Create Room | Tap create | Room created | ⬜ |
| ROOM-A.4 | Join Room | Tap join | Joined as audience | ⬜ |
| ROOM-A.5 | Request to Speak | Raise hand | Request sent | ⬜ |
| ROOM-A.6 | Become Speaker | Host accepts | Now speaker | ⬜ |
| ROOM-A.7 | Send Reaction | Tap emoji | Animation shown | ⬜ |
| ROOM-A.8 | Room Chat | Open chat | Messages displayed | ⬜ |
| ROOM-A.9 | Leave Room | Tap leave | Left room | ⬜ |
| ROOM-A.10 | Host Controls | As host | Mute/kick options | ⬜ |

### Phase 8: Social Feed

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| FEED-A.1 | Feed Load | Open feed | Posts displayed | ⬜ |
| FEED-A.2 | Pull Refresh | Pull down | New posts loaded | ⬜ |
| FEED-A.3 | Infinite Scroll | Scroll down | More posts loaded | ⬜ |
| FEED-A.4 | Like Post | Tap like | Heart animation | ⬜ |
| FEED-A.5 | Unlike Post | Tap again | Like removed | ⬜ |
| FEED-A.6 | View Comments | Tap comments | Comment thread | ⬜ |
| FEED-A.7 | Add Comment | Type & post | Comment appears | ⬜ |
| FEED-A.8 | Create Post | Tap create | Post composer | ⬜ |
| FEED-A.9 | Add Photo | Select image | Image attached | ⬜ |
| FEED-A.10 | Add Video | Select video | Video attached | ⬜ |
| FEED-A.11 | Post with Media | Submit post | Post created | ⬜ |
| FEED-A.12 | Translate Post | Tap translate | Text translated | ⬜ |
| FEED-A.13 | Share Post | Tap share | Share options | ⬜ |
| FEED-A.14 | Save Post | Tap save | Post saved | ⬜ |
| FEED-A.15 | Video Autoplay | Scroll to video | Video plays | ⬜ |

### Phase 9: Speech Learning

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| SL-A.1 | SL Home | Open SL tab | Main screen | ⬜ |
| SL-A.2 | Tongue Twisters | View list | Levels displayed | ⬜ |
| SL-A.3 | Locked Level | Tap locked | Unlock prompt | ⬜ |
| SL-A.4 | Unlock Level | Confirm unlock | Level unlocked | ⬜ |
| SL-A.5 | Record Pronunciation | Tap record | Recording starts | ⬜ |
| SL-A.6 | Stop Recording | Tap stop | Recording stops | ⬜ |
| SL-A.7 | View Score | After analysis | Score displayed | ⬜ |
| SL-A.8 | View Breakdown | Tap details | Phoneme scores | ⬜ |
| SL-A.9 | Play Reference | Tap play | Audio plays | ⬜ |
| SL-A.10 | Leaderboard | View leaderboard | Rankings shown | ⬜ |
| SL-A.11 | Personal Best | View my scores | History shown | ⬜ |

### Phase 10: Gifts & Economy

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| GIFT-A.1 | Gift Shop | Open gifts | Categories displayed | ⬜ |
| GIFT-A.2 | Browse Gifts | Scroll | 3D icons visible | ⬜ |
| GIFT-A.3 | Filter Category | Select filter | Filtered gifts | ⬜ |
| GIFT-A.4 | Wallet Display | Check wallet | Balance shown | ⬜ |
| GIFT-A.5 | Coin Store | Tap add coins | Packages shown | ⬜ |
| GIFT-A.6 | Purchase Coins | Select package | IAP flow | ⬜ |
| GIFT-A.7 | Send Gift | Select & send | Confirmation | ⬜ |
| GIFT-A.8 | Gift Animation | Send premium | Lottie plays | ⬜ |
| GIFT-A.9 | Transaction History | View history | List displayed | ⬜ |
| GIFT-A.10 | Insufficient Coins | Try expensive | Error message | ⬜ |

### Phase 11: Partner Matching

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| MATCH-A.1 | Discovery Deck | Open matching | Cards displayed | ⬜ |
| MATCH-A.2 | Swipe Right | Swipe right | Next card | ⬜ |
| MATCH-A.3 | Swipe Left | Swipe left | Next card | ⬜ |
| MATCH-A.4 | Super Like | Tap super like | Match created | ⬜ |
| MATCH-A.5 | Undo Swipe | Tap undo | Previous card | ⬜ |
| MATCH-A.6 | Compatibility Score | View card | Score displayed | ⬜ |
| MATCH-A.7 | Match Animation | Mutual like | Match screen | ⬜ |
| MATCH-A.8 | View Matches | Tap matches | List displayed | ⬜ |
| MATCH-A.9 | Start Chat | Tap match | Open conversation | ⬜ |
| MATCH-A.10 | Filter Discovery | Set filters | Filtered results | ⬜ |
| MATCH-A.11 | Leaderboard | View top | Rankings shown | ⬜ |

### Phase 12: Notifications

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| NOTIF-A.1 | Receive Push | Get notification | Notification shows | ⬜ |
| NOTIF-A.2 | Tap Notification | Tap notification | App opens to relevant | ⬜ |
| NOTIF-A.3 | Notification List | View all | Glass cards | ⬜ |
| NOTIF-A.4 | Mark Read | Tap notification | Marked as read | ⬜ |
| NOTIF-A.5 | Mark All Read | Tap mark all | All marked | ⬜ |
| NOTIF-A.6 | Delete Notification | Swipe delete | Removed | ⬜ |
| NOTIF-A.7 | Badge Count | Unread count | Badge accurate | ⬜ |
| NOTIF-A.8 | Settings | Open settings | Toggles visible | ⬜ |
| NOTIF-A.9 | Toggle Type | Disable messages | No message notifs | ⬜ |
| NOTIF-A.10 | Custom Sounds | Receive call | Custom sound | ⬜ |

---

## 🔒 Security Testing

### Authentication Security

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| SEC-1.1 | SQL Injection | Enter `' OR 1=1 --` | Sanitized/rejected | ⬜ |
| SEC-1.2 | XSS Attempt | Enter `<script>alert(1)</script>` | Escaped | ⬜ |
| SEC-1.3 | Brute Force | 10 failed logins | Account locked | ⬜ |
| SEC-1.4 | Token Expiry | Use expired token | 401 Unauthorized | ⬜ |
| SEC-1.5 | Token Tampering | Modify token | 401 Unauthorized | ⬜ |
| SEC-1.6 | HTTPS Only | HTTP request | Redirect to HTTPS | ⬜ |
| SEC-1.7 | Password Strength | Weak password | Rejected | ⬜ |
| SEC-1.8 | Session Timeout | Wait 24 hours | Session expired | ⬜ |

### Data Security

| Test ID | Test Name | Steps | Expected | Status |
|---------|-----------|-------|----------|--------|
| SEC-2.1 | Private Data | Access others data | 403 Forbidden | ⬜ |
| SEC-2.2 | Deleted Data | Access deleted | Not found | ⬜ |
| SEC-2.3 | Sensitive Exposure | Check responses | No passwords/tokens | ⬜ |
| SEC-2.4 | File Upload | Upload executable | Rejected | ⬜ |
| SEC-2.5 | Path Traversal | Use `../../../` | Sanitized | ⬜ |

---

## ⚡ Performance Testing

### API Performance

| Test ID | Test Name | Metric | Target | Status |
|---------|-----------|--------|--------|--------|
| PERF-1.1 | Auth Response | Response time | < 200ms | ⬜ |
| PERF-1.2 | List Response | Response time | < 300ms | ⬜ |
| PERF-1.3 | Search Response | Response time | < 500ms | ⬜ |
| PERF-1.4 | Concurrent Users | 1000 req/sec | No errors | ⬜ |
| PERF-1.5 | Database Queries | Query count | < 10 per request | ⬜ |

### APK Performance

| Test ID | Test Name | Metric | Target | Status |
|---------|-----------|--------|--------|--------|
| PERF-2.1 | App Launch | Cold start | < 3 seconds | ⬜ |
| PERF-2.2 | Screen Load | Navigation | < 500ms | ⬜ |
| PERF-2.3 | Scroll FPS | Feed scroll | 60 FPS | ⬜ |
| PERF-2.4 | Memory Usage | Peak memory | < 200MB | ⬜ |
| PERF-2.5 | Battery Usage | 1 hour use | < 10% | ⬜ |
| PERF-2.6 | Network Usage | 1 hour use | < 50MB | ⬜ |

---

## 📊 Testing Execution Checklist

### Pre-Testing
- [ ] Environment setup complete
- [ ] Test data seeded
- [ ] Test users created
- [ ] API server running
- [ ] APK installed on device
- [ ] Network monitoring tools ready

### Daily Testing
- [ ] Run unit tests
- [ ] Execute API test suite
- [ ] Run APK smoke tests
- [ ] Check error logs
- [ ] Update test status

### Weekly Testing
- [ ] Full regression test
- [ ] Performance benchmarks
- [ ] Security scan
- [ ] Cross-browser/device test
- [ ] Accessibility audit

### Release Testing
- [ ] All P1 tests pass
- [ ] All P2 tests pass
- [ ] Performance targets met
- [ ] Security scan clean
- [ ] Documentation updated
- [ ] Release notes prepared

---

## 🐛 Bug Reporting Template

```
**Bug ID:** BUG-XXX
**Severity:** Critical/High/Medium/Low
**Priority:** P0/P1/P2/P3
**Component:** API/APK/Both
**Phase:** 0-12

**Summary:** Brief description

**Steps to Reproduce:**
1. Step one
2. Step two
3. Step three

**Expected Result:** What should happen
**Actual Result:** What actually happens

**Environment:**
- OS: Android 14 / iOS 17
- Device: Pixel 7 / iPhone 15
- App Version: 1.0.0
- API Version: v1

**Screenshots:** Attach images
**Logs:** Attach relevant logs
**Test Case:** Link to test case ID
```

---

## 📈 Test Metrics

Track these metrics throughout testing:

| Metric | Target | Current |
|--------|--------|---------|
| Test Coverage | 90% | — |
| Pass Rate | 95% | — |
| Critical Bugs | 0 | — |
| High Bugs | < 5 | — |
| Avg Response Time | < 300ms | — |
| Crash Rate | < 0.1% | — |

---

## 🔄 Continuous Testing

### CI/CD Pipeline
```yaml
# .github/workflows/test.yml
name: Test Suite
on: [push, pull_request]

jobs:
  api-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
      - name: Install dependencies
        run: cd api && composer install
      - name: Run tests
        run: cd api && php artisan test

  apk-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.27.0'
      - name: Install dependencies
        run: cd apk && flutter pub get
      - name: Run tests
        run: cd apk && flutter test
```

---

**Next Steps:**
1. Set up test environment
2. Begin Phase 0 testing
3. Report bugs using template
4. Update metrics daily
5. Prepare for Phase 10 release

*Last Updated: February 28, 2026*
