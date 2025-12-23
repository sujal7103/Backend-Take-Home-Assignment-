# API Testing Guide

This document provides example requests for testing all API endpoints.

## Prerequisites

- Application running on `http://localhost:3000`
- MongoDB running and connected
- Tool like `curl`, Postman, or Thunder Client

## 1. Create Session (Idempotent)

**Request:**
```bash
curl -X POST http://localhost:3000/sessions \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "session-abc-123",
    "language": "en",
    "metadata": {
      "source": "mobile-app",
      "userId": "user-456",
      "deviceType": "iOS"
    }
  }'
```

**Expected Response (200 OK):**
```json
{
  "sessionId": "session-abc-123",
  "status": "initiated",
  "language": "en",
  "startedAt": "2025-12-21T15:30:00.000Z",
  "endedAt": null,
  "metadata": {
    "source": "mobile-app",
    "userId": "user-456",
    "deviceType": "iOS"
  }
}
```

**Idempotency Test:**
Run the same request again - should return the exact same session (same `startedAt` time).

---

## 2. Add Event to Session

**Request:**
```bash
curl -X POST http://localhost:3000/sessions/session-abc-123/events \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "evt-001",
    "type": "user_speech",
    "payload": {
      "text": "What is the weather today?",
      "confidence": 0.95,
      "duration": 2.3,
      "language": "en-US"
    }
  }'
```

**Expected Response (201 Created):**
```json
{
  "eventId": "evt-001",
  "sessionId": "session-abc-123",
  "type": "user_speech",
  "payload": {
    "text": "What is the weather today?",
    "confidence": 0.95,
    "duration": 2.3,
    "language": "en-US"
  },
  "timestamp": "2025-12-21T15:30:15.123Z"
}
```

**Add More Events:**
```bash
# Bot response
curl -X POST http://localhost:3000/sessions/session-abc-123/events \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "evt-002",
    "type": "bot_speech",
    "payload": {
      "text": "Today it will be sunny with a high of 75°F",
      "confidence": 0.98,
      "duration": 3.1
    }
  }'

# System event
curl -X POST http://localhost:3000/sessions/session-abc-123/events \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "evt-003",
    "type": "system",
    "payload": {
      "action": "intent_detected",
      "intent": "weather_query",
      "confidence": 0.92
    }
  }'

# Another user speech
curl -X POST http://localhost:3000/sessions/session-abc-123/events \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "evt-004",
    "type": "user_speech",
    "payload": {
      "text": "Thank you!",
      "confidence": 0.97,
      "duration": 0.8
    }
  }'
```

**Idempotency Test:**
Run any event creation again with the same `eventId` - should return the existing event.

---

## 3. Get Session with Events

**Request (Default Pagination):**
```bash
curl http://localhost:3000/sessions/session-abc-123
```

**Request (Custom Pagination):**
```bash
curl "http://localhost:3000/sessions/session-abc-123?page=1&limit=2"
```

**Expected Response (200 OK):**
```json
{
  "sessionId": "session-abc-123",
  "status": "initiated",
  "language": "en",
  "startedAt": "2025-12-21T15:30:00.000Z",
  "endedAt": null,
  "metadata": {
    "source": "mobile-app",
    "userId": "user-456",
    "deviceType": "iOS"
  },
  "events": [
    {
      "eventId": "evt-004",
      "type": "user_speech",
      "payload": {
        "text": "Thank you!",
        "confidence": 0.97,
        "duration": 0.8
      },
      "timestamp": "2025-12-21T15:31:00.000Z"
    },
    {
      "eventId": "evt-003",
      "type": "system",
      "payload": {
        "action": "intent_detected",
        "intent": "weather_query",
        "confidence": 0.92
      },
      "timestamp": "2025-12-21T15:30:45.000Z"
    }
  ],
  "pagination": {
    "total": 4,
    "page": 1,
    "limit": 2,
    "totalPages": 2
  }
}
```

**Note:** Events are returned in reverse chronological order (newest first).

---

## 4. Complete Session

**Request:**
```bash
curl -X POST http://localhost:3000/sessions/session-abc-123/complete
```

**Expected Response (200 OK):**
```json
{
  "sessionId": "session-abc-123",
  "status": "completed",
  "language": "en",
  "startedAt": "2025-12-21T15:30:00.000Z",
  "endedAt": "2025-12-21T15:31:30.000Z",
  "metadata": {
    "source": "mobile-app",
    "userId": "user-456",
    "deviceType": "iOS"
  }
}
```

**Idempotency Test:**
Run the same completion request again - should return the same `endedAt` time.

---

## Error Cases

### Session Not Found

**Request:**
```bash
curl http://localhost:3000/sessions/non-existent-session
```

**Expected Response (404 Not Found):**
```json
{
  "statusCode": 404,
  "timestamp": "2025-12-21T15:32:00.000Z",
  "path": "/sessions/non-existent-session",
  "method": "GET",
  "error": "Not Found",
  "message": "Session non-existent-session not found"
}
```

### Add Event to Non-Existent Session

**Request:**
```bash
curl -X POST http://localhost:3000/sessions/fake-session/events \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "evt-999",
    "type": "user_speech",
    "payload": {"text": "Test"}
  }'
```

**Expected Response (404 Not Found):**
```json
{
  "statusCode": 404,
  "timestamp": "2025-12-21T15:33:00.000Z",
  "path": "/sessions/fake-session/events",
  "method": "POST",
  "error": "Not Found",
  "message": "Session fake-session not found"
}
```

### Invalid Event Type

**Request:**
```bash
curl -X POST http://localhost:3000/sessions/session-abc-123/events \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "evt-bad",
    "type": "invalid_type",
    "payload": {"text": "Test"}
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "statusCode": 400,
  "timestamp": "2025-12-21T15:34:00.000Z",
  "path": "/sessions/session-abc-123/events",
  "method": "POST",
  "error": "Bad Request",
  "message": [
    "type must be one of the following values: user_speech, bot_speech, system"
  ]
}
```

### Missing Required Fields

**Request:**
```bash
curl -X POST http://localhost:3000/sessions \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "incomplete-session"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "statusCode": 400,
  "timestamp": "2025-12-21T15:35:00.000Z",
  "path": "/sessions",
  "method": "POST",
  "error": "Bad Request",
  "message": [
    "language should not be empty",
    "language must be a string"
  ]
}
```

---

## Testing Concurrency

To test concurrent requests, you can use multiple terminal windows or a tool like `ab` (Apache Bench):

```bash
# Install apache bench if needed (macOS)
brew install httpd

# Run 100 concurrent requests creating the same session
ab -n 100 -c 10 -p session-data.json -T application/json http://localhost:3000/sessions
```

Where `session-data.json` contains:
```json
{
  "sessionId": "concurrent-test",
  "language": "en",
  "metadata": {"test": "concurrency"}
}
```

All requests should succeed and return the same session data.

---

## Full Test Flow

Here's a complete test sequence:

```bash
SESSION_ID="test-flow-$(date +%s)"

# 1. Create session
curl -X POST http://localhost:3000/sessions \
  -H "Content-Type: application/json" \
  -d "{\"sessionId\": \"$SESSION_ID\", \"language\": \"en\"}"

# 2. Add multiple events
for i in {1..5}; do
  curl -X POST "http://localhost:3000/sessions/$SESSION_ID/events" \
    -H "Content-Type: application/json" \
    -d "{\"eventId\": \"evt-$i\", \"type\": \"system\", \"payload\": {\"count\": $i}}"
done

# 3. Get session with events
curl "http://localhost:3000/sessions/$SESSION_ID?page=1&limit=10"

# 4. Complete session
curl -X POST "http://localhost:3000/sessions/$SESSION_ID/complete"

# 5. Verify completion
curl "http://localhost:3000/sessions/$SESSION_ID"
```

---

## Performance Testing

Use `wrk` or `ab` for load testing:

```bash
# Install wrk (macOS)
brew install wrk

# Test session creation throughput
wrk -t4 -c100 -d30s --latency \
  -s scripts/post-session.lua \
  http://localhost:3000/sessions
```

Expected performance:
- Session creation: 1000+ req/s
- Event addition: 2000+ req/s
- Session retrieval: 3000+ req/s

---

## Postman Collection

Import this JSON into Postman for easier testing:

```json
{
  "info": {
    "name": "Conversation Session Service",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Create Session",
      "request": {
        "method": "POST",
        "header": [{"key": "Content-Type", "value": "application/json"}],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"sessionId\": \"{{$randomUUID}}\",\n  \"language\": \"en\",\n  \"metadata\": {\"source\": \"postman\"}\n}"
        },
        "url": {"raw": "{{baseUrl}}/sessions", "host": ["{{baseUrl}}"], "path": ["sessions"]}
      }
    }
  ],
  "variable": [
    {"key": "baseUrl", "value": "http://localhost:3000"}
  ]
}
```

---

## Cleanup

To reset the database between tests:

```bash
mongosh
> use conversation-service
> db.conversationsessions.deleteMany({})
> db.conversationevents.deleteMany({})
```
