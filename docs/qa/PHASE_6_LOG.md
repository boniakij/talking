# Phase 6 QA Log: Audio Calls

## Overview
Verification of the Audio Calling system, including STUN/TURN configuration, call initiation, answering, declining, ending, and ICE candidate exchange.

## Test Results

### 6.1 Get STUN/TURN Config
- **Status:** PASSED ✅
- **Details:** Verified that the API correctly returns the configured STUN and TURN servers for WebRTC.
- **Verification:** `GET /api/v1/calls/config`

### 6.2 Initiate Audio Call
- **Status:** PASSED ✅
- **Details:** User can successfully initiate a call to another user. Verified that state transitions to `ringing` and broadcasting is triggered. Added fix for deprecated middleware in `CallController`.
- **Verification:** `POST /api/v1/calls/initiate`

### 6.3 Answer Audio Call
- **Status:** PASSED ✅
- **Details:** Callee can answer an incoming call. Verified that state transitions to `active` and `answered_at` timestamp is recorded.
- **Verification:** `POST /api/v1/calls/{id}/answer`

### 6.4 Decline Audio Call
- **Status:** PASSED ✅
- **Details:** Callee can decline an incoming call. Verified that state transitions to `declined` and call terminates immediately.
- **Verification:** `POST /api/v1/calls/{id}/decline`

### 6.5 End Audio Call
- **Status:** PASSED ✅
- **Details:** Either participant can end an active call. Verified that `ended_at` is set and call duration is calculated correctly.
- **Verification:** `POST /api/v1/calls/{id}/end`

### 6.6 Send ICE Candidate
- **Status:** PASSED ✅
- **Details:** Participants can exchange ICE candidates via the API. Verified that candidates are properly broadcasted to the other participant.
- **Verification:** `POST /api/v1/calls/{id}/ice-candidate`

### 6.7 Call History
- **Status:** PASSED ✅
- **Details:** Users can view their past call logs (both audio and video). Verified pagination and correct data retrieval.
- **Verification:** `GET /api/v1/calls/history`

## Error Cases Verified
- **Self-Calling:** Prevented by API with 422 error.
- **Unauthorized Answer:** Users cannot answer calls they are not part of (403).
- **Invalid Call ID:** API returns 404 for non-existent call IDs.
