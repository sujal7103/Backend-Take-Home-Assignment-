# Design Document

## 1. How did you ensure idempotency?

Idempotency is ensured through several mechanisms:

### Session Creation (POST /sessions)
- **MongoDB's `findOneAndUpdate` with `upsert: true`**: This atomic operation either creates a new session or returns the existing one based on the unique `sessionId`.
- **Unique Index**: The `sessionId` field has a unique index, preventing duplicate sessions at the database level.
- **$setOnInsert**: Only sets fields during initial creation, ensuring repeated requests don't overwrite existing session data.

### Event Creation (POST /sessions/:sessionId/events)
- **Compound Unique Index**: A unique index on `(sessionId, eventId)` prevents duplicate events for the same session.
- **Duplicate Key Handling**: When a duplicate event is detected (MongoDB error code 11000), the repository returns the existing event instead of throwing an error, making the operation idempotent.
- **Immutable Events**: Events are never updated, only created, which simplifies idempotency guarantees.

### Session Completion (POST /sessions/:sessionId/complete)
- **Status Check**: Before updating, the service checks if the session is already completed and returns the current state if so.
- **Atomic Update**: Uses `findOneAndUpdate` to atomically set the completion status and timestamp.

## 2. How does your design behave under concurrent requests?

The design handles concurrency through MongoDB's atomic operations and proper indexing:

### Database-Level Concurrency Control
- **Atomic Operations**: All create/update operations use MongoDB's atomic `findOneAndUpdate` or `insertOne`, which are internally locked at the document level.
- **Unique Constraints**: Unique indexes on `sessionId` and `(sessionId, eventId)` prevent race conditions when multiple requests try to create the same resource simultaneously.

### Concurrent Session Creation
- When multiple requests try to create the same session:
  1. First request creates the session
  2. Subsequent requests get the existing session due to `upsert: false` with new: false behavior
  3. All requests receive the same session data

### Concurrent Event Creation
- When multiple requests try to add the same event:
  1. First request succeeds
  2. Subsequent requests catch the duplicate key error (11000)
  3. Repository fetches and returns the existing event
  4. All requests receive the same event data

### Concurrent Session Completion
- Multiple completion requests are safe because:
  1. The operation is atomic via `findOneAndUpdate`
  2. Status check ensures already-completed sessions return immediately
  3. The `endedAt` timestamp might differ slightly, but this is acceptable behavior

### Limitations
- **No Distributed Locking**: This design relies on MongoDB's single-document atomicity. For multi-document transactions or complex workflows, distributed locks would be needed.
- **Read-Then-Write**: Some operations check state before updating, which could have race conditions, but atomic updates mitigate this.

## 3. What MongoDB indexes did you choose and why?

### ConversationSession Collection

```javascript
{ sessionId: 1 } // Unique index
{ status: 1 }
{ startedAt: -1 }
```

**Rationale:**
- **sessionId (unique)**: Primary lookup field for all session operations. Unique constraint enforces business rule.
- **status**: Enables efficient filtering of sessions by status (e.g., finding all active sessions).
- **startedAt**: Supports time-based queries and sorting sessions chronologically.

### ConversationEvent Collection

```javascript
{ sessionId: 1, timestamp: -1 } // Compound index
{ sessionId: 1, eventId: 1 }    // Unique compound index
{ timestamp: -1 }
```

**Rationale:**
- **sessionId + timestamp (compound)**: Optimizes the most common query pattern - fetching events for a session ordered by time. The compound index covers both filtering and sorting.
- **sessionId + eventId (unique compound)**: Enforces business rule that eventId must be unique per session, enabling idempotent event creation.
- **timestamp**: Supports global time-based queries across all events.

### Index Selection Strategy
1. **Query Patterns First**: Indexes are chosen based on actual API requirements
2. **Compound Index Order**: Most selective field first (sessionId), then sort field (timestamp)
3. **Covering Indexes**: Compound indexes reduce need for additional lookups
4. **Balance**: Limited number of indexes to avoid write performance degradation

## 4. How would you scale this system for millions of sessions per day?

### Short-Term Scaling (1-10M sessions/day)

#### Database Level
1. **MongoDB Replica Set**: 
   - Primary for writes, secondaries for read-heavy operations
   - Configure read preference for session retrieval (secondary preferred)
   - Automatic failover for high availability

2. **Connection Pooling**:
   - Increase connection pool size in Mongoose configuration
   - Monitor and tune based on concurrent request patterns

3. **Query Optimization**:
   - Ensure all queries use indexes (use `.explain()` to verify)
   - Add projections to limit returned fields
   - Implement cursor-based pagination instead of offset-based

#### Application Level
4. **Horizontal Scaling**:
   - Deploy multiple NestJS instances behind a load balancer
   - Stateless design allows seamless horizontal scaling
   - Use PM2 or Kubernetes for orchestration

5. **Caching Layer**:
   - Add Redis for frequently accessed sessions
   - Cache session details with TTL
   - Invalidate cache on completion
   - Implement read-through caching pattern

6. **Rate Limiting**:
   - Implement rate limiting per API key/client
   - Prevent abuse and ensure fair resource distribution

### Medium-Term Scaling (10-100M sessions/day)

7. **Database Sharding**:
   - Shard by `sessionId` using hash-based sharding
   - Ensures even distribution of data
   - Each shard handles subset of sessions

8. **Event Storage Optimization**:
   - Consider time-series collection for events (MongoDB 5.0+)
   - Archive old events to cold storage (S3) after certain period
   - Implement TTL indexes for automatic cleanup

9. **Async Processing**:
   - Offload heavy operations to message queues (RabbitMQ/Kafka)
   - Process analytics and aggregations asynchronously
   - Implement CQRS pattern for read/write separation

10. **CDN and Edge Computing**:
    - Use CDN for static content
    - Deploy edge functions for geo-distributed clients
    - Reduce latency for global users

### Long-Term Scaling (100M+ sessions/day)

11. **Microservices Architecture**:
    - Split into separate services: SessionService, EventService, AnalyticsService
    - Independent scaling based on load patterns
    - Event-driven architecture with message bus

12. **Multi-Region Deployment**:
    - Deploy in multiple geographic regions
    - Cross-region replication for disaster recovery
    - Route users to nearest region

13. **Advanced Monitoring**:
    - Implement distributed tracing (Jaeger/Zipkin)
    - Real-time alerting for anomalies
    - Capacity planning based on metrics

### Performance Targets
- **Latency**: P95 < 100ms for session creation, < 50ms for event addition
- **Throughput**: 10,000+ requests/second per instance
- **Availability**: 99.9% uptime

## 5. What did you intentionally keep out of scope, and why?

### Authentication & Authorization
**Why**: The assignment explicitly states "no authentication required". In production, we would implement:
- JWT-based authentication
- Role-based access control (RBAC)
- API key management for external clients

### Background Jobs & Queues
**Why**: Requirement states "no background jobs or queues". In production, we would add:
- Queue for event processing
- Background jobs for analytics aggregation
- Scheduled cleanup of old data

### External Services Integration
**Why**: "No external services" requirement. Production features would include:
- Webhook notifications for session events
- Integration with analytics platforms
- External logging services (DataDog, New Relic)

### Advanced Testing
**Why**: Time constraints and focus on core functionality. Would add:
- Comprehensive unit tests for all services
- Integration tests for API endpoints
- Load testing to verify performance targets
- Contract tests for API stability

### Observability & Monitoring
**Partial Implementation**: Basic logging is included, but production needs:
- Structured logging with correlation IDs
- APM (Application Performance Monitoring)
- Real-time dashboards and alerts
- Health check endpoints

### Data Validation & Sanitization
**Partial Implementation**: Basic DTO validation exists, but would enhance:
- Input sanitization against injection attacks
- More sophisticated validation rules
- Custom validators for business logic

### Session State Transitions
**Why**: Simplified for assignment. Production would enforce:
- Strict state machine for session status transitions
- Validation preventing invalid status changes
- Audit trail for all state changes

### Event Ordering Guarantees
**Why**: Complexity vs. benefit. Current design orders by timestamp, but doesn't guarantee:
- Strict causal ordering of events
- Exactly-once event delivery
- Event replay capabilities

### Data Retention & Archival
**Why**: Out of scope for MVP. Production needs:
- Automatic archival of old sessions
- Compliance with data retention policies
- GDPR-compliant data deletion

### Rate Limiting & Throttling
**Why**: Not required for assignment. Production must have:
- Per-client rate limiting
- Adaptive throttling under high load
- DDoS protection

### API Versioning
**Why**: Single version for assignment. Production requires:
- API versioning strategy (URL or header-based)
- Backward compatibility guarantees
- Deprecation policy

### Error Recovery & Resilience
**Partial Implementation**: Basic error handling exists, but would add:
- Circuit breakers for external dependencies
- Retry logic with exponential backoff
- Graceful degradation strategies

### Documentation
**Partial Implementation**: Code comments and this document exist, but would add:
- OpenAPI/Swagger specification
- Postman collection for API testing
- Architecture decision records (ADRs)
- Runbooks for operations

---

## Technology Choices

### Why NestJS?
- Strong TypeScript support with decorators
- Built-in dependency injection
- Modular architecture scales well
- Extensive ecosystem and community

### Why MongoDB?
- Flexible schema for metadata field
- Strong consistency with replica sets
- Excellent indexing capabilities
- Horizontal scaling via sharding

### Why Mongoose?
- Type-safe schema definitions
- Built-in validation
- Middleware support
- Active maintenance and community

---

## Future Improvements

If given more time, I would prioritize:

1. **Comprehensive Testing**: Unit + integration + e2e tests
2. **Performance Benchmarking**: Load tests to validate scaling claims
3. **API Documentation**: OpenAPI/Swagger for consumer clarity
4. **Enhanced Observability**: Structured logging, metrics, tracing
5. **State Machine**: Enforce valid session status transitions
6. **Soft Deletes**: Add ability to mark sessions as deleted without removing data
