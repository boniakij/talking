#!/bin/bash

BASE_URL="http://127.0.0.1:8000/api/v1"
TOKEN_QA="10|ruP6qG73bfc3EunOTWB8CwPqSZgFOi2UDx03N3HXb9552c02"
TOKEN_QA2="11|TTgr28ZltPBThfTpRYTefeJ975s83iBOemARyf5Bc7a6cead"
ID_QA=3
ID_QA2=4

echo "--- 7.1: Initiate video call (QA -> QA2) ---"
INITIATE_RESPONSE=$(curl -s -X POST "$BASE_URL/video/initiate" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"callee_id\": $ID_QA2,
    \"sdp_offer\": {\"type\": \"offer\", \"sdp\": \"v=0\\r\\no=- 12345 67890 IN IP4 0.0.0.0\\r\\ns=-\\r\\nt=0 0\\r\\n...video...\"}
  }")
echo "$INITIATE_RESPONSE" | jq .
CALL_ID=$(echo "$INITIATE_RESPONSE" | jq -r '.data.id')

echo -e "\n--- 7.2: Answer video call (QA2) ---"
curl -s -X POST "$BASE_URL/video/$CALL_ID/answer" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"sdp_answer\": {\"type\": \"answer\", \"sdp\": \"v=0\\r\\no=- 67890 12345 IN IP4 0.0.0.0\\r\\ns=-\\r\\nt=0 0\\r\\n...video...\"}
  }" | jq .

echo -e "\n--- 7.6: Toggle video (QA: off) ---"
curl -s -X POST "$BASE_URL/video/$CALL_ID/toggle-video" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"enabled\": false
  }" | jq .

echo -e "\n--- 7.5: Send ICE candidate (QA2) ---"
curl -s -X POST "$BASE_URL/video/$CALL_ID/ice-candidate" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"candidate\": {\"candidate\": \"...video...\", \"sdpMid\": \"0\", \"sdpMLineIndex\": 0}
  }" | jq .

echo -e "\n--- 7.4: End video call (QA2) ---"
curl -s -X POST "$BASE_URL/video/$CALL_ID/end" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 7.3: Decline video call (New call QA -> QA2) ---"
NEW_CALL_RESPONSE=$(curl -s -X POST "$BASE_URL/video/initiate" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"callee_id\": $ID_QA2,
    \"sdp_offer\": {\"type\": \"offer\", \"sdp\": \"...video...\"}
  }")
NEW_CALL_ID=$(echo "$NEW_CALL_RESPONSE" | jq -r '.data.id')

curl -s -X POST "$BASE_URL/video/$NEW_CALL_ID/decline" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 7.7: Video call history (QA) ---"
curl -s -X GET "$BASE_URL/video/history" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .
