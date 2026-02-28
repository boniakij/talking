#!/bin/bash

BASE_URL="http://127.0.0.1:8000/api/v1"
TOKEN_QA="12|mVoPBpbX7LXgs2Hh2A1Xtvzmyxa5eObP83Tzqugv6daea988"
TOKEN_QA2="13|YUL5cOgfhxihKULdJUw18IVmzPm6QxLm8r3xJuuW5e6a3308"
TOKEN_QA3="14|eEdOQSEL11gHTjHQDfsOUoSgOQLYv4dOAfRp6vBze70913db"
ID_QA=3
ID_QA2=4
ID_QA3=5

echo "--- 8.2: Create Voice Room (QA) ---"
CREATE_RESPONSE=$(curl -s -X POST "$BASE_URL/rooms" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"title\": \"Test Room\",
    \"description\": \"QA testing room\",
    \"is_public\": true,
    \"capacity\": 10
  }")
echo "$CREATE_RESPONSE" | jq .
ROOM_ID=$(echo "$CREATE_RESPONSE" | jq -r '.data.id')

echo -e "\n--- 8.1: List public rooms ---"
curl -s -X GET "$BASE_URL/rooms" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.7: Join room (QA2, QA3) ---"
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/join" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Accept: application/json" | jq .
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/join" \
  -H "Authorization: Bearer $TOKEN_QA3" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.9: Request to speak (QA2) ---"
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/speak" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.10: Promote to speaker (QA -> QA2) ---"
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/speakers/$ID_QA2" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.13: Add co-host (QA -> QA2) ---"
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/cohosts/$ID_QA2" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.15: Send reaction (QA3) ---"
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/reactions" \
  -H "Authorization: Bearer $TOKEN_QA3" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"emoji\": \"🔥\"}" | jq .

echo -e "\n--- 8.14: Remove co-host (QA) ---"
curl -s -X DELETE "$BASE_URL/rooms/$ROOM_ID/cohosts/$ID_QA2" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.11: Demote speaker (QA -> QA2) ---"
curl -s -X DELETE "$BASE_URL/rooms/$ROOM_ID/speakers/$ID_QA2" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.12: Kick participant (QA -> QA3) ---"
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/kick/$ID_QA3" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.8: Leave room (QA2) ---"
curl -s -X POST "$BASE_URL/rooms/$ROOM_ID/leave" \
  -H "Authorization: Bearer $TOKEN_QA2" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.4: Update room settings (QA) ---"
curl -s -X PUT "$BASE_URL/rooms/$ROOM_ID" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"title\": \"Updated Test Room\"}" | jq .

echo -e "\n--- 8.3: View room detail ---"
curl -s -X GET "$BASE_URL/rooms/$ROOM_ID" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.6: Room history ---"
curl -s -X GET "$BASE_URL/rooms/history" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 8.5: Close/Delete room (QA) ---"
curl -s -X DELETE "$BASE_URL/rooms/$ROOM_ID" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .
