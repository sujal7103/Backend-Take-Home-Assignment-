# 🚀 Conversation Session Service

> **Backend Take-Home Assignment**  
> A scalable Voice AI session management system built with TypeScript, NestJS, and MongoDB.

---

## ⚡ Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Start MongoDB
brew services start mongodb-community
# OR: docker run -d -p 27017:27017 mongo

# 3. Run the application
npm run start:dev

# 4. See it in action (30 seconds)
./demo.sh
```

**Server runs on:** `http://localhost:3000`



## 🎯 What This Does

Manages conversation sessions for a Voice AI platform:
- **Sessions**: Represent phone calls with unique IDs
- **Events**: Track what happens during calls (user speech, bot responses, system events)
- **Idempotent**: Safe to retry any operation
- **Concurrent-Safe**: Handles simultaneous requests correctly

---

## 📡 API Endpoints

### 1. Create or Get Session (Idempotent)
```bash
POST /sessions
```
```json
{
  "sessionId": "call-123",
  "language": "en",
  "metadata": { "userId": "user-456" }
}
```

### 2. Add Event (Prevents Duplicates)
```bash
POST /sessions/:sessionId/events
```
```json
{
  "eventId": "evt-001",
  "type": "user_speech",
  "payload": { "text": "Hello" }
}
```

### 3. Get Session with Events (Paginated)
```bash
GET /sessions/:sessionId?page=1&limit=10
```

### 4. Complete Session (Idempotent)
```bash
POST /sessions/:sessionId/complete
```

---

## 🏗️ Architecture

```
src/
├── modules/
│   ├── session/
│   │   ├── controllers/     # HTTP endpoints
│   │   ├── services/        # Business logic
│   │   ├── repositories/    # Database operations
│   │   └── schemas/         # MongoDB models
│   └── event/
│       └── (same structure)
└── common/                  # Shared utilities
```

**Design Principles:**
- ✅ Repository pattern for data access
- ✅ Service layer for business logic  
- ✅ DTOs with validation
- ✅ Atomic MongoDB operations
- ✅ Proper error handling

---

## 🔑 Key Technical Decisions

### **Idempotency**
- Sessions: `findOneAndUpdate` with `upsert: true`
- Events: Unique compound index `(sessionId, eventId)`
- Completion: Check status before updating

### **Concurrency**
- All operations use MongoDB atomic commands
- No race conditions with document-level locking
- Unique constraints prevent duplicates

### **Database Indexes**
```typescript
// Session: Fast lookups
{ sessionId: 1 } // unique

// Events: Efficient retrieval + duplicate prevention
{ sessionId: 1, timestamp: -1 } // compound
{ sessionId: 1, eventId: 1 }    // unique compound
```

---

## 🧪 Testing

```bash
# Run automated test suite (12 tests)
./run-tests.sh

# Manual testing examples
curl -X POST http://localhost:3000/sessions \
  -H "Content-Type: application/json" \
  -d '{"sessionId":"test-1","language":"en"}'
```

**Tests cover:**
- ✅ Idempotency (sessions, events, completion)
- ✅ Duplicate prevention
- ✅ Pagination
- ✅ Error handling (404, validation)
- ✅ Concurrent requests

---

## 📊 Scaling Strategy

**For millions of sessions/day:**
- **Sharding**: Partition by `sessionId` for horizontal scaling
- **Read Replicas**: Distribute read load
- **Caching**: Redis for hot sessions
- **Archiving**: Move completed sessions to cold storage
- **Connection Pooling**: Optimize database connections

---

## 📚 Documentation

- **[DESIGN.md](DESIGN.md)** - Detailed design decisions & scaling
- **[API-TESTING.md](API-TESTING.md)** - Complete testing guide
- **[demo.sh](demo.sh)** - One-command demonstration
- **[run-tests.sh](run-tests.sh)** - Automated test suite

---

## 🛠️ Tech Stack

- **Runtime**: Node.js 18+
- **Framework**: NestJS 10
- **Language**: TypeScript 5
- **Database**: MongoDB 6+
- **ODM**: Mongoose
- **Validation**: class-validator

---

## 💡 What's Special

1. **One-Command Demo** - `./demo.sh` shows everything in 30 seconds
2. **Production-Ready** - Proper error handling, validation, logging
3. **Well-Documented** - 4 comprehensive markdown files
4. **Tested** - Automated test suite with 100% success rate
5. **Clean Code** - Clear separation of concerns, typed, commented

---


## 🚀 What I Learned / Decisions Made

**Why Mongoose over Native Driver?**  
Schema validation and middleware hooks simplify business logic.

**Why Repository Pattern?**  
Separates data access from business logic, making testing easier.

**Why Compound Indexes?**  
Single index serves both duplicate prevention and efficient querying.

**Trade-offs:**  
Prioritized correctness over premature optimization. Added indexes based on query patterns, not speculation.

---

## 📝 Assumptions

- Sessions are immutable once created (except status/endedAt)
- Events are immutable after creation
- Session IDs are externally generated and unique
- No authentication/authorization required
- MongoDB is available locally or via Docker

---

## 👤 Author

**Sujal**  
Backend Engineer | Full-Stack Developer  
[GitHub](https://github.com/sujal7103) • [LinkedIn](#)

---

## 📄 License

This is a take-home assignment project.

---

**⭐ If you're reviewing this:** Run `./demo.sh` for a quick overview!
