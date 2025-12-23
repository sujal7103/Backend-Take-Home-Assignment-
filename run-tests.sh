#!/bin/bash

BASE_URL="http://localhost:3000"
TIMESTAMP=$(date +%s)
SESSION_ID="test-session-$TIMESTAMP"

echo "🧪 Testing Conversation Session Service API"
echo "=============================================="
echo ""

# Test 1: Create a session
echo "✅ Test 1: Creating new session ($SESSION_ID)"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d "{
    \"sessionId\": \"$SESSION_ID\",
    \"language\": \"en\",
    \"metadata\": {
      \"source\": \"test-script\",
      \"timestamp\": $TIMESTAMP
    }
  }")
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 2: Test idempotency - create same session again
echo "✅ Test 2: Testing idempotency (creating same session again)"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d "{
    \"sessionId\": \"$SESSION_ID\",
    \"language\": \"fr\",
    \"metadata\": {
      \"source\": \"different-source\"
    }
  }")
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 3: Add an event
echo "✅ Test 3: Adding event to session"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-001",
    "type": "user_speech",
    "payload": {
      "text": "Hello, how are you?",
      "confidence": 0.95
    }
  }')
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 4: Add same event again (idempotency)
echo "✅ Test 4: Testing event idempotency (adding same event again)"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-001",
    "type": "bot_speech",
    "payload": {
      "text": "Different text"
    }
  }')
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 5: Add more events
echo "✅ Test 5: Adding more events"
curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-002",
    "type": "bot_speech",
    "payload": {"text": "I am doing great!"}
  }' > /dev/null

curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-003",
    "type": "system",
    "payload": {"action": "session_extended"}
  }' > /dev/null

echo "Added 2 more events (event-002, event-003)"
echo ""
echo "---"
echo ""

# Test 6: Get session with events
echo "✅ Test 6: Getting session with events (paginated)"
RESPONSE=$(curl -s "$BASE_URL/sessions/$SESSION_ID?page=1&limit=10")
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 7: Complete session
echo "✅ Test 7: Completing session"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/complete")
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 8: Complete again (idempotency)
echo "✅ Test 8: Testing completion idempotency (completing again)"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/complete")
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 9: Error case - non-existent session
echo "🚫 Test 9: Error case - Getting non-existent session"
RESPONSE=$(curl -s "$BASE_URL/sessions/non-existent-session-12345")
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 10: Error case - add event to non-existent session
echo "🚫 Test 10: Error case - Adding event to non-existent session"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/fake-session-999/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-999",
    "type": "user_speech",
    "payload": {"text": "Test"}
  }')
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 11: Error case - invalid event type
echo "🚫 Test 11: Error case - Invalid event type"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-invalid",
    "type": "invalid_type",
    "payload": {"text": "Test"}
  }')
echo "$RESPONSE"
echo ""
echo "---"
echo ""

# Test 12: Error case - missing required fields
echo "🚫 Test 12: Error case - Missing required fields"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "incomplete-session"
  }')
echo "$RESPONSE"
echo ""
echo "---"
echo ""

echo "=============================================="
echo "✨ All tests completed!"
echo "=============================================="
echo ""
echo "Test session ID: $SESSION_ID"
echo "You can verify the completed session with:"
echo "curl $BASE_URL/sessions/$SESSION_ID"
