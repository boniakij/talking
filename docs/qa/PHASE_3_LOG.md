# Phase 3: Social Features (Follow/Block) — Testing Log
**Date:** 2026-02-26
**Actors:**
- User 1: `qauser` (ID 3)
- User 2: `qauser2` (ID 4)

## 3.1 Follow a user
- **Command:** `POST /api/v1/users/4/follow` (as User 1)
- **Result:** PASSED
- **Evidence:** User 2 followers count 0 -> 1. User 1 following count 0 -> 1.

## 3.2 Unfollow a user
- **Command:** `DELETE /api/v1/users/4/follow` (as User 1)
- **Result:** PASSED
- **Evidence:** Counts successfully decremented.

## 3.3 Get followers list
- **Command:** `GET /api/v1/users/4/followers`
- **Result:** PASSED (After fix)
- **Fix Applied:** Removed `withTimestamps()` from `followers` relationship in `User.php` as the `follows` table lacks `updated_at`.
- **Evidence:** Returned paginated list of followers with relationship flags (`is_following`, etc.).

## 3.4 Get following list
- **Command:** `GET /api/v1/users/3/following`
- **Result:** PASSED (After fix)
- **Fix Applied:** Removed `withTimestamps()` from `following` relationship in `User.php`.
- **Evidence:** Returned list of users followed by User 1.

## 3.5 Block a user
- **Command:** `POST /api/v1/users/4/block`
- **Result:** PASSED
- **Evidence:** Follow relationships between both users automatically deleted. Relationship flags updated.

## 3.6 Unblock a user
- **Command:** `DELETE /api/v1/users/4/block`
- **Result:** PASSED
- **Evidence:** Block record removed from database.

## 3.7 Get blocked users list
- **Command:** `GET /api/v1/users/blocked`
- **Result:** PASSED (After fix)
- **Fix Applied:** Removed `withTimestamps()` from `blockedUsers` relationship in `User.php`.
- **Evidence:** Correctly listed User 4 while blocked.

## 3.8 Verify block constraints
- **Test:** View Profile 4 as User 1 while blocked.
- **Result:** PASSED (After fix)
- **Fix Applied:** Added `hasBlockedOrIsBlockedBy` check to `ProfileController@show`. Previously it only checked `is_public`.
- **Evidence:** API returned `404 User not found` for both users attempting to view each other's profiles while blocked.

---
**Status: ALL PASSED ✅**
