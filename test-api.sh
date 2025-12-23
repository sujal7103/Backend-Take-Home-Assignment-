#!/bin/bash

# Test script for Conversation Session Service API
# Run this script to test all endpoints

BASE_URL="http://localhost:3000"

echo "🧪 Testing Conversation Session Service API"
echo "=========================================="
echo ""

# Test 1: Create a new session
echo "✅ Test 1: Create a new session"
curl -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "test-session-001",
    "language": "en",
    "metadata": {
      "source": "test-script",
      "userId": "user-123"
    }
  }' | jq '.'
echo -e "\n"

# Test 2: Create same session again (test idempotency)
echo "✅ Test 2: Create same session again (idempotency test)"
curl -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "test-session-001",
    "language": "fr",
    "metadata": {
      "source": "different-source"
    }
  }' | jq '.'
echo -e "\n"

# Test 3: Add an event to the session
echo "✅ Test 3: Add an event to the session"
curl -X POST "$BASE_URL/sessions/test-session-001/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-001",
    "type": "user_speech",
    "payload": {
      "text": "Hello, how are you?",
      "confidence": 0.95,
      "duration": 2.5
    }
  }' | jq '.'
echo -e "\n"

# Test 4: Add same event again (test idempotency)
echo "✅ Test 4: Add same event again (idempotency test)"
curl -X POST "$BASE_URL/sessions/test-session-001/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-001",
    "type": "bot_speech",
    "payload": {
      "text": "Different text",
      "confidence": 0.80
    }
  }' | jq '.'
echo -e "\n"

# Test 5: Add another event
echo "✅ Test 5: Add another event"
curl -X POST "$BASE_URL/sessions/test-session-001/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-002",
    "type": "bot_speech",
    "payload": {
      "text": "I am doing great, thank you!",
      "confidence": 0.98
    }
  }' | jq '.'
echo -e "\n"

# Test 6: Add third event
echo "✅ Test 6: Add third event"
curl -X POST "$BASE_URL/sessions/test-session-001/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-003",
    "type": "system",
    "payload": {
      "action": "session_extended",
      "reason": "user_active"
    }
  }' | jq '.'
echo -e "\n"

# Test 7: Get session with events (default pagination)
echo "✅ Test 7: Get session with events (default pagination)"
curl "$BASE_URL/sessions/test-session-001" | jq '.'
echo -e "\n"

# Test 8: Get session with custom pagination
echo "✅ Test 8: Get session with pagination (page=1, limit=2)"
curl "$BASE_URL/sessions/test-session-001?page=1&limit=2" | jq '.'
echo -e "\n"

# Test 9: Complete the session
echo "✅ Test 9: Complete the session"
curl -X POST "$BASE_URL/sessions/test-session-001/complete" | jq '.'
echo -e "\n"

# Test 10: Complete same session again (test idempotency)
echo "✅ Test 10: Complete same session again (idempotency test)"
curl -X POST "$BASE_URL/sessions/test-session-001/complete" | jq '.'
echo -e "\n"

# Test 11: Get completed session
echo "✅ Test 11: Get completed session"
curl "$BASE_URL/sessions/test-session-001" | jq '.'
echo -e "\n"

# Test 12: Error case - Get non-existent session
echo "🚫 Test 12: Error case - Get non-existent session"
curl "$BASE_URL/sessions/non-existent-session" | jq '.'
echo -e "\n"

# Test 13: Error case - Add event to non-existent session
echo "🚫 Test 13: Error case - Add event to non-existent session"
curl -X POST "$BASE_URL/sessions/non-existent-session/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-999",
    "type": "user_speech",
    "payload": {"text": "Test"}
  }' | jq '.'
echo -e "\n"

# Test 14: Error case - Invalid event type
echo "🚫 Test 14: Error case - Invalid event type"
curl -X POST "$BASE_URL/sessions/test-session-001/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-invalid",
    "type": "invalid_type",
    "payload": {"text": "Test"}
  }' | jq '.'
echo -e "\n"

# Test 15: Error case - Missing required fields
echo "🚫 Test 15: Error case - Missing required fields"
curl -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "test-incomplete"
  }' | jq '.'
echo -e "\n"

echo "=========================================="
echo "✨ All tests completed!"
echo "=========================================="
