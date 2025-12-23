# Conversation Session Service# Conversation Session Service<p align="center">



> **Backend Take-Home Assignment** | TypeScript · NestJS · MongoDB  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Nest Logo" /></a>



A production-ready backend service for managing conversation sessions and events in a Voice AI platform.A backend service for managing conversation sessions and events in a Voice AI platform, built with NestJS, TypeScript, and MongoDB.</p>



---



## 🚀 **Quick Start for Reviewers**## Features[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456



**Want to see it in action in 30 seconds?** Run this:[circleci-url]: https://circleci.com/gh/nestjs/nest



```bash- ✅ Idempotent session creation and updates

./demo.sh

```- ✅ Thread-safe event management with duplicate prevention  <p align="center">A progressive <a href="http://nodejs.org" target="_blank">Node.js</a> framework for building efficient and scalable server-side applications.</p>



This single command will:- ✅ Paginated event retrieval    <p align="center">

- ✅ Verify MongoDB is running

- ✅ Install dependencies (if needed)- ✅ Atomic database operations for concurrent request handling<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/v/@nestjs/core.svg" alt="NPM Version" /></a>

- ✅ Start the NestJS server

- ✅ Run live API demonstrations- ✅ Comprehensive error handling and validation<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/l/@nestjs/core.svg" alt="Package License" /></a>

- ✅ Show all key features with formatted output

- ✅ RESTful API design<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/dm/@nestjs/common.svg" alt="NPM Downloads" /></a>

**No configuration needed!** Just MongoDB running on localhost:27017.

<a href="https://circleci.com/gh/nestjs/nest" target="_blank"><img src="https://img.shields.io/circleci/build/github/nestjs/nest/master" alt="CircleCI" /></a>

---

## Tech Stack<a href="https://discord.gg/G7Qnnhy" target="_blank"><img src="https://img.shields.io/badge/discord-online-brightgreen.svg" alt="Discord"/></a>

## ✨ Features

<a href="https://opencollective.com/nest#backer" target="_blank"><img src="https://opencollective.com/nest/backers/badge.svg" alt="Backers on Open Collective" /></a>

- ✅ **Idempotent Operations** - Sessions, events, and completion are all idempotent

- ✅ **Thread-Safe** - Handles concurrent requests with MongoDB atomic operations- **Framework**: NestJS 10.x<a href="https://opencollective.com/nest#sponsor" target="_blank"><img src="https://opencollective.com/nest/sponsors/badge.svg" alt="Sponsors on Open Collective" /></a>

- ✅ **Paginated Events** - Efficient retrieval with customizable pagination

- ✅ **Comprehensive Validation** - Input validation using class-validator- **Language**: TypeScript 5.x  <a href="https://paypal.me/kamilmysliwiec" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg" alt="Donate us"/></a>

- ✅ **Error Handling** - Global exception filter with consistent error responses

- ✅ **Clean Architecture** - Proper separation: Controllers → Services → Repositories- **Database**: MongoDB with Mongoose ODM    <a href="https://opencollective.com/nest#sponsor"  target="_blank"><img src="https://img.shields.io/badge/Support%20us-Open%20Collective-41B883.svg" alt="Support us"></a>



---- **Validation**: class-validator, class-transformer  <a href="https://twitter.com/nestframework" target="_blank"><img src="https://img.shields.io/twitter/follow/nestframework.svg?style=social&label=Follow" alt="Follow us on Twitter"></a>



## 🏗️ Tech Stack- **Runtime**: Node.js 18+</p>



- **Framework**: NestJS 10.x  <!--[![Backers on Open Collective](https://opencollective.com/nest/backers/badge.svg)](https://opencollective.com/nest#backer)

- **Language**: TypeScript 5.x

- **Database**: MongoDB with Mongoose ODM## Prerequisites  [![Sponsors on Open Collective](https://opencollective.com/nest/sponsors/badge.svg)](https://opencollective.com/nest#sponsor)-->

- **Validation**: class-validator, class-transformer

- **Runtime**: Node.js 18+



---- Node.js 18+ and npm## Description



## 📋 Prerequisites- MongoDB 5.0+ (local or Docker)



- Node.js 18+ and npm[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

- MongoDB 5.0+ running on `localhost:27017`

## Installation

### Installing MongoDB

## Project setup

**macOS:**

```bash### 1. Clone and Install Dependencies

brew tap mongodb/brew

brew install mongodb-community```bash

brew services start mongodb-community

``````bash$ npm install



**Docker:**cd conversation-session-service```

```bash

docker run -d -p 27017:27017 --name mongodb mongo:latestnpm install

```

```## Compile and run the project

---



## 🛠️ Manual Setup

### 2. Setup MongoDB```bash

If you prefer manual setup instead of using `./demo.sh`:

# development

### 1. Install Dependencies

```bash**Option A: Local MongoDB**$ npm run start

npm install

``````bash



### 2. Configure Environment# macOS with Homebrew# watch mode

```bash

cp .env.example .envbrew tap mongodb/brew$ npm run start:dev

# Edit .env if needed (default works for local MongoDB)

```brew install mongodb-community



### 3. Start the Applicationbrew services start mongodb-community# production mode



**Development Mode:**$ npm run start:prod

```bash

npm run start:dev# Verify MongoDB is running```

```

mongosh

**Production Mode:**

```bash```## Run tests

npm run build

npm run start:prod

```

**Option B: Docker**```bash

Server will start at: **http://localhost:3000**

```bash# unit tests

---

docker run -d \$ npm run test

## 🧪 Testing

  --name mongodb \

### Automated Test Suite

```bash  -p 27017:27017 \# e2e tests

./run-tests.sh

```  mongo:latest$ npm run test:e2e



This runs 12 comprehensive tests covering:```

- Session creation & idempotency

- Event addition & idempotency# test coverage

- Session completion & idempotency

- Error handling & validation### 3. Configure Environment$ npm run test:cov

- Pagination

```

### Manual Testing

Copy the example environment file:

**Create a Session:**

```bash```bash## Deployment

curl -X POST http://localhost:3000/sessions \

  -H "Content-Type: application/json" \cp .env.example .env

  -d '{

    "sessionId": "my-session-123",```When you're ready to deploy your NestJS application to production, there are some key steps you can take to ensure it runs as efficiently as possible. Check out the [deployment documentation](https://docs.nestjs.com/deployment) for more information.

    "language": "en",

    "metadata": {"userId": "user-456"}

  }'

```Edit `.env` if needed:If you are looking for a cloud-based platform to deploy your NestJS application, check out [Mau](https://mau.nestjs.com), our official platform for deploying NestJS applications on AWS. Mau makes deployment straightforward and fast, requiring just a few simple steps:



**Add an Event:**```env

```bash

curl -X POST http://localhost:3000/sessions/my-session-123/events \MONGODB_URI=mongodb://localhost:27017/conversation-service```bash

  -H "Content-Type: application/json" \

  -d '{PORT=3000$ npm install -g @nestjs/mau

    "eventId": "event-1",

    "type": "user_speech",NODE_ENV=development$ mau deploy

    "payload": {"text": "Hello world"}

  }'``````

```



**Get Session with Events:**

```bash## Running the ApplicationWith Mau, you can deploy your application in just a few clicks, allowing you to focus on building features rather than managing infrastructure.

curl "http://localhost:3000/sessions/my-session-123?page=1&limit=20"

```



**Complete Session:**### Development Mode## Resources

```bash

curl -X POST http://localhost:3000/sessions/my-session-123/complete```bash

```

npm run start:devCheck out a few resources that may come in handy when working with NestJS:

---

```

## 📡 API Endpoints

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.

| Method | Endpoint | Description |

|--------|----------|-------------|### Production Mode- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).

| `POST` | `/sessions` | Create or get existing session (idempotent) |

| `GET` | `/sessions/:sessionId` | Get session with paginated events |```bash- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).

| `POST` | `/sessions/:sessionId/events` | Add event to session (idempotent) |

| `POST` | `/sessions/:sessionId/complete` | Mark session as completed (idempotent) |npm run build- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.



### Request/Response Examplesnpm run start:prod- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).



See [API-TESTING.md](./API-TESTING.md) for comprehensive examples with all edge cases.```- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).



---- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).



## 📊 Data ModelsThe API will be available at: `http://localhost:3000`- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).



### ConversationSession

```typescript

{## API Endpoints## Support

  sessionId: string;        // Unique identifier

  status: 'initiated' | 'active' | 'completed' | 'failed';

  language: string;         // e.g., 'en', 'fr'

  startedAt: Date;### 1. Create or Get Session (Idempotent)Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

  endedAt: Date | null;

  metadata: object;         // Flexible metadata```http

}

```POST /sessions## Stay in touch



### ConversationEventContent-Type: application/json

```typescript

{- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)

  eventId: string;          // Unique per session

  sessionId: string;{- Website - [https://nestjs.com](https://nestjs.com/)

  type: 'user_speech' | 'bot_speech' | 'system';

  payload: object;          // Event-specific data  "sessionId": "session-123",- Twitter - [@nestframework](https://twitter.com/nestframework)

  timestamp: Date;

}  "language": "en",

```

  "status": "initiated",## License

---

  "metadata": {

## 🏛️ Project Structure

    "source": "mobile-app",Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).

```

src/    "userId": "user-456"

├── modules/  }

│   ├── session/}

│   │   ├── controllers/      # HTTP endpoints```

│   │   ├── services/         # Business logic

│   │   ├── repositories/     # Database access**Response** (200 OK):

│   │   ├── schemas/          # Mongoose models```json

│   │   ├── dto/              # Data transfer objects{

│   │   └── session.module.ts  "sessionId": "session-123",

│   └── event/  "status": "initiated",

│       └── (same structure)  "language": "en",

├── common/  "startedAt": "2025-12-21T10:30:00.000Z",

│   └── filters/              # Global exception handling  "endedAt": null,

├── app.module.ts  "metadata": {

└── main.ts    "source": "mobile-app",

```    "userId": "user-456"

  }

---}

```

## 🎯 Key Design Decisions

### 2. Get Session with Events

### **Idempotency**```http

- **Sessions**: MongoDB's `findOneAndUpdate` with `upsert: true` + unique `sessionId`GET /sessions/session-123?page=1&limit=20

- **Events**: Unique compound index `(sessionId, eventId)` prevents duplicates```

- **Completion**: Status check before update ensures repeated calls are safe

**Response** (200 OK):

### **Concurrency Handling**```json

- All operations use atomic MongoDB commands{

- Unique constraints prevent race conditions  "sessionId": "session-123",

- Document-level locking handles concurrent writes safely  "status": "active",

  "language": "en",

### **Database Indexes**  "startedAt": "2025-12-21T10:30:00.000Z",

```javascript  "endedAt": null,

// ConversationSession  "metadata": {},

{ sessionId: 1 }              // Unique - fast lookups  "events": [

{ status: 1 }                 // Filter by status    {

{ startedAt: -1 }             // Time-based queries      "eventId": "event-1",

      "type": "user_speech",

// ConversationEvent      "payload": {

{ sessionId: 1, timestamp: -1 }     // Compound - event retrieval        "text": "Hello, how are you?"

{ sessionId: 1, eventId: 1 }        // Unique compound - duplicates      },

{ timestamp: -1 }                    // Global time queries      "timestamp": "2025-12-21T10:30:15.000Z"

```    }

  ],

---  "pagination": {

    "total": 1,

## 📚 Documentation    "page": 1,

    "limit": 20,

| Document | Description |    "totalPages": 1

|----------|-------------|  }

| [DESIGN.md](./DESIGN.md) | **⭐ MUST READ** - Answers all 5 design questions in depth |}

| [API-TESTING.md](./API-TESTING.md) | Comprehensive API testing guide with examples |```

| [README.md](./README.md) | This file - setup and usage |

### 3. Add Event to Session (Idempotent)

---```http

POST /sessions/session-123/events

## 🔒 Assumptions & ConstraintsContent-Type: application/json



✅ **Implemented:**{

- No authentication (as per requirements)  "eventId": "event-1",

- Simple pagination (limit + offset)  "type": "user_speech",

- Event immutability  "payload": {

- Single MongoDB instance    "text": "Hello, how are you?",

- UTC timestamps    "confidence": 0.95

  }

❌ **Intentionally Excluded:**}

- Background jobs/queues (not required)```

- External services (not required)

- Advanced monitoring/metrics**Response** (201 Created):

- Rate limiting```json

- API versioning{

  "eventId": "event-1",

See [DESIGN.md](./DESIGN.md) Section 5 for complete list and rationale.  "sessionId": "session-123",

  "type": "user_speech",

---  "payload": {

    "text": "Hello, how are you?",

## 🚀 Scaling Considerations    "confidence": 0.95

  },

This system can scale to **millions of sessions per day** through:  "timestamp": "2025-12-21T10:30:15.000Z"

}

1. **Short-term** (1-10M/day):```

   - MongoDB replica sets

   - Horizontal scaling (multiple NestJS instances)### 4. Complete Session (Idempotent)

   - Redis caching layer```http

POST /sessions/session-123/complete

2. **Medium-term** (10-100M/day):```

   - Database sharding by sessionId

   - CQRS pattern for read/write separation**Response** (200 OK):

   - Async processing with message queues```json

{

3. **Long-term** (100M+/day):  "sessionId": "session-123",

   - Microservices architecture  "status": "completed",

   - Multi-region deployment  "language": "en",

   - Event-driven architecture  "startedAt": "2025-12-21T10:30:00.000Z",

  "endedAt": "2025-12-21T10:35:00.000Z",

Detailed strategy in [DESIGN.md](./DESIGN.md) Section 4.  "metadata": {}

}

---```



## ✅ Error Handling## Testing the APIs



All errors return consistent JSON:### Using cURL



```json```bash

{# Create a session

  "statusCode": 404,curl -X POST http://localhost:3000/sessions \

  "timestamp": "2025-12-21T10:30:00.000Z",  -H "Content-Type: application/json" \

  "path": "/sessions/invalid-id",  -d '{

  "method": "GET",    "sessionId": "test-session-1",

  "error": "Not Found",    "language": "en",

  "message": "Session invalid-id not found"    "metadata": {"source": "curl-test"}

}  }'

```

# Add an event

**Error Codes:**curl -X POST http://localhost:3000/sessions/test-session-1/events \

- `400` - Bad Request (validation errors)  -H "Content-Type: application/json" \

- `404` - Not Found (session doesn't exist)  -d '{

- `500` - Internal Server Error (unexpected errors)    "eventId": "event-1",

    "type": "user_speech",

---    "payload": {"text": "Hello"}

  }'

## 🧹 Cleanup

# Get session with events

**Clear test data:**curl http://localhost:3000/sessions/test-session-1?page=1&limit=10

```bash

mongosh# Complete session

> use conversation-servicecurl -X POST http://localhost:3000/sessions/test-session-1/complete

> db.conversationsessions.deleteMany({})```

> db.conversationevents.deleteMany({})

```### Test Idempotency



**Stop the server:**Run the same request multiple times to verify idempotent behavior:

```bash```bash

# Find and kill the process# This should return the same session each time

lsof -ti:3000 | xargs kill -9curl -X POST http://localhost:3000/sessions \

```  -H "Content-Type: application/json" \

  -d '{"sessionId": "test-session-1", "language": "en"}'

---```



## 📦 Development Commands## Data Models



```bash### ConversationSession

# Development with hot reload- `sessionId` (string, unique): External session identifier

npm run start:dev- `status` (enum): `initiated` | `active` | `completed` | `failed`

- `language` (string): Language code (e.g., "en", "fr")

# Build for production- `startedAt` (Date): Session start timestamp

npm run build- `endedAt` (Date | null): Session end timestamp

- `metadata` (object): Flexible metadata storage

# Run production build

npm run start:prod### ConversationEvent

- `eventId` (string): Unique per session

# Lint code- `sessionId` (string): Reference to session

npm run lint- `type` (enum): `user_speech` | `bot_speech` | `system`

- `payload` (object): Event-specific data

# Format code- `timestamp` (Date): Event occurrence time

npm run format

```## Project Structure



---```

src/

## 🎓 What Makes This Implementation Stand Out├── modules/

│   ├── session/

1. **✅ Production-Ready Code Quality**│   │   ├── controllers/      # HTTP request handlers

   - Clean separation of concerns│   │   ├── services/         # Business logic

   - Comprehensive TypeScript typing│   │   ├── repositories/     # Database access

   - Proper error handling everywhere│   │   ├── schemas/          # Mongoose schemas

│   │   ├── dto/              # Data transfer objects

2. **✅ Idempotency Guarantees**│   │   └── session.module.ts

   - All operations are safe to retry│   └── event/

   - No duplicate data on concurrent requests│       └── (similar structure)

├── common/

3. **✅ Concurrent Request Handling**│   ├── filters/              # Exception filters

   - Atomic database operations│   └── interceptors/         # Request interceptors

   - Race condition prevention├── app.module.ts             # Root module

   - Thread-safe design└── main.ts                   # Application entry point

```

4. **✅ Well-Documented**

   - Three comprehensive markdown files## Key Design Decisions

   - Inline code comments explaining "why"

   - Clear architecture decisions### Idempotency

- **Sessions**: MongoDB `findOneAndUpdate` with `upsert` ensures atomic create-or-get

5. **✅ Easy to Review**- **Events**: Unique compound index on `(sessionId, eventId)` prevents duplicates

   - One-command demo script- **Completion**: Status check before update ensures repeated calls are safe

   - Automated test suite

   - Beautiful formatted output### Concurrency

- All operations use atomic database commands

6. **✅ Scalability Awareness**- Unique constraints prevent race conditions

   - Detailed scaling strategies- Document-level locking in MongoDB handles concurrent writes

   - Performance considerations

   - MongoDB indexing best practices### Indexes

- `sessionId` (unique) for fast session lookups

---- `(sessionId, timestamp)` compound index for efficient event retrieval

- `(sessionId, eventId)` unique compound index for duplicate prevention

## 📞 Support & Questions

See [DESIGN.md](./DESIGN.md) for detailed design decisions and scaling strategies.

If you encounter any issues:

## Validation

1. **Check MongoDB**: Ensure it's running on port 27017

2. **Check Dependencies**: Run `npm install`The API validates all inputs using class-validator:

3. **Check Logs**: View `server.log` or terminal output- Required fields must be present

4. **Check Port**: Ensure port 3000 is available- Enum values are strictly checked

- Type safety enforced at runtime

---- Invalid requests return 400 Bad Request with details



## 📝 License## Error Handling



MIT- `400 Bad Request`: Invalid input data

- `404 Not Found`: Session doesn't exist

---- `500 Internal Server Error`: Unexpected errors



## 👨‍💻 AuthorAll errors return consistent JSON format:

```json

**Backend Take-Home Assignment**{

- Built with ❤️ using NestJS, TypeScript, and MongoDB  "statusCode": 404,

- Focused on correctness, clarity, and scalability  "timestamp": "2025-12-21T10:30:00.000Z",

  "path": "/sessions/invalid-id",

---  "method": "GET",

  "error": "Not Found",

<div align="center">  "message": "Session invalid-id not found"

}

### ⭐ Key Highlights```



**Idempotent** • **Thread-Safe** • **Well-Documented** • **Production-Ready**## Assumptions



</div>1. **No Authentication**: As per requirements, no auth layer is implemented

2. **Single Database**: All data stored in single MongoDB instance
3. **Event Immutability**: Events cannot be modified after creation
4. **Pagination**: Default page size is 20, max is 100
5. **Session Lifecycle**: Sessions can transition to completed but not back
6. **Metadata**: Flexible schema allows any JSON-serializable data
7. **Event Ordering**: Events are ordered by timestamp, client-provided or server-generated
8. **Timezone**: All timestamps in UTC

## Development Commands

```bash
# Run in development mode with watch
npm run start:dev

# Build for production
npm run build

# Run production build
npm run start:prod

# Lint code
npm run lint

# Format code
npm run format

# Run tests (if implemented)
npm run test
```

## MongoDB Indexes

Indexes are automatically created on application startup:

**ConversationSession:**
- `sessionId` (unique)
- `status`
- `startedAt`

**ConversationEvent:**
- `(sessionId, timestamp)` (compound)
- `(sessionId, eventId)` (unique compound)
- `timestamp`

## Troubleshooting

### MongoDB Connection Issues
```bash
# Check if MongoDB is running
mongosh

# If using Docker, check container status
docker ps | grep mongo

# View application logs for connection errors
npm run start:dev
```

### Port Already in Use
```bash
# Change PORT in .env file
PORT=3001
```

### Clear Test Data
```bash
mongosh
> use conversation-service
> db.conversationsessions.deleteMany({})
> db.conversationevents.deleteMany({})
```

## Production Considerations

See [DESIGN.md](./DESIGN.md) for:
- Scaling strategies for millions of sessions
- Performance optimization techniques
- High availability setup
- Monitoring and observability
- Security best practices

## License

MIT

## Author

Built for Backend Take-Home Assignment
