#!/bin/bash

BASE_URL="http://127.0.0.1:8000/api/v1"
TOKEN_QA="30|iVIOUXCRlA10YajW9BRMtRQClxw3Ove9bEGAoMuB09efe951"
TOKEN_QA2="31|mIRoplfirZIKpuMLSunfVDCE9g18SXMQyGDixJrRd7fcf63d"
ID_QA2=4

echo "--- 12.1: Get matching preferences ---"
curl -s -X GET "$BASE_URL/matching/preferences" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq .

echo -e "\n--- 12.2: Update matching preferences ---"
curl -s -X PUT "$BASE_URL/matching/preferences" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"preferred_languages\": [\"es\"], \"age_min\": 20, \"age_max\": 40}" | jq .

echo -e "\n--- 12.3: Get match suggestions ---"
SUGGESTIONS=$(curl -s -X GET "$BASE_URL/matching/suggestions" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json")
echo "$SUGGESTIONS" | jq '.data[0,1]'
MATCHED_USER_ID=$(echo "$SUGGESTIONS" | jq -r '.data[0].user.id')
DECLINE_USER_ID=$(echo "$SUGGESTIONS" | jq -r '.data[1].user.id')

echo -e "\n--- 12.4: Accept match (Mutual) ---"
if [ "$MATCHED_USER_ID" != "null" ]; then
  curl -s -X POST "$BASE_URL/matching/accept/$MATCHED_USER_ID" \
    -H "Authorization: Bearer $TOKEN_QA" \
    -H "Accept: application/json" | jq .
else
  echo "No suggestion found to accept."
fi

echo -e "\n--- 12.6: List my matches ---"
curl -s -X GET "$BASE_URL/matching/matches" \
  -H "Authorization: Bearer $TOKEN_QA" \
  -H "Accept: application/json" | jq '.data[0]'

echo -e "\n--- 12.5: Decline match ---"
if [ "$DECLINE_USER_ID" != "null" ]; then
  curl -s -X POST "$BASE_URL/matching/decline/$DECLINE_USER_ID" \
    -H "Authorization: Bearer $TOKEN_QA" \
    -H "Accept: application/json" | jq .
else
  echo "No second suggestion found to decline."
fi
