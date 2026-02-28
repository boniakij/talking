#!/bin/bash

BASE_URL="http://127.0.0.1:8000/api/v1"
TOKEN_QA="10|ruP6qG73bfc3EunOTWB8CwPqSZgFOi2UDx03N3HXb9552c02"
TOKEN_QA2="11|TTgr28ZltPBThfTpRYTefeJ975s83iBOemARyf5Bc7a6cead"
ID_QA=3
ID_QA2=4

echo "--- 6.1: Get STUN/TURN config ---"
curl -s -X GET "$BASE_URL/calls/config" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 6.2: Initiate call (QA -> QA2) ---"
INITIATE_RESPONSE=$(curl -s -X POST "$BASE_URL/calls/initiate" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"callee_id\": $ID_QA2,
    \"sdp_offer\": {\"type\": \"offer\", \"sdp\": \"v=0\\r\\no=- 12345 67890 IN IP4 0.0.0.0\\r\\ns=-\\r\\nt=0 0\\r\\n...\"}
  }")
echo "$INITIATE_RESPONSE" | jq .
CALL_ID=$(echo "$INITIATE_RESPONSE" | jq -r '.data.id')

echo -e "\n--- 6.2.e1: Initiate Self-Call (Error) ---"
curl -s -X POST "$BASE_URL/calls/initiate" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"callee_id\": $ID_QA,
    \"sdp_offer\": {\"type\": \"offer\", \"sdp\": \"...\"}
  }" | jq .

echo -e "\n--- 6.3: Answer call (QA2) ---"
curl -s -X POST "$BASE_URL/calls/$CALL_ID/answer" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"sdp_answer\": {\"type\": \"answer\", \"sdp\": \"v=0\\r\\no=- 67890 12345 IN IP4 0.0.0.0\\r\\ns=-\\r\\nt=0 0\\r\\n...\"}
  }" | jq .

echo -e "\n--- 6.6: Send ICE candidate (QA) ---"
curl -s -X POST "$BASE_URL/calls/$CALL_ID/ice-candidate" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"candidate\": {\"candidate\": \"...\", \"sdpMid\": \"0\", \"sdpMLineIndex\": 0}
  }" | jq .

echo -e "\n--- 6.5: End call (QA) ---"
curl -s -X POST "$BASE_URL/calls/$CALL_ID/end" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 6.4: Decline call (New call QA -> QA2) ---"
NEW_CALL_RESPONSE=$(curl -s -X POST "$BASE_URL/calls/initiate" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"callee_id\": $ID_QA2,
    \"sdp_offer\": {\"type\": \"offer\", \"sdp\": \"...\"}
  }")
NEW_CALL_ID=$(echo "$NEW_CALL_RESPONSE" | jq -r '.data.id')

curl -s -X POST "$BASE_URL/calls/$NEW_CALL_ID/decline" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 6.7: Call history (QA) ---"
curl -s -X GET "$BASE_URL/calls/history" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .
