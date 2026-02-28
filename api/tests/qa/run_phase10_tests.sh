#!/bin/bash

BASE_URL="http://127.0.0.1:8000/api/v1"
TOKEN_QA="21|ZBcY3U4D7uHyhL35SXBQMe17QrFmYRi1VZAf10PG0fd1096f"
TOKEN_QA2="22|VBlecTrAmCaGSG3qsGZFQtyy7vVRTRLJSjl8ZuZfa6d8e7d1"
ID_POST=7
ID_MESSAGE=4

echo "--- 10.1: List supported languages ---"
curl -s -X GET "$BASE_URL/translations/languages" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq '.data[0,1,2]'

echo -e "\n--- 10.2: Detect language ---"
curl -s -X GET "$BASE_URL/translations/detect?text=Hello+world" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 10.3: Translate arbitrary text ---"
curl -s -X POST "$BASE_URL/translations/text" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"text\": \"I love testing!\", \"target_lang\": \"es\"}" | jq .

echo -e "\n--- 10.4: Translate message ---"
TRANSLATE_MSG_RES=$(curl -s -X GET "$BASE_URL/translations/message/$ID_MESSAGE?target_lang=es" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json")
echo "$TRANSLATE_MSG_RES" | jq .
TRANS_ID=$(echo "$TRANSLATE_MSG_RES" | jq -r '.data.id')

echo -e "\n--- 10.5: Translate post ---"
curl -s -X GET "$BASE_URL/translations/post/$ID_POST?target_lang=fr" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 10.6: Score translation quality ---"
curl -s -X POST "$BASE_URL/translations/$TRANS_ID/score" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"rating\": 5, \"feedback\": \"Excellent mock translation!\"}" | jq .
