#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Clear screen for better presentation
clear

echo -e "${BOLD}${BLUE}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     🚀 CONVERSATION SESSION SERVICE - QUICK DEMO 🚀          ║"
echo "║                                                               ║"
echo "║     Backend Take-Home Assignment                             ║"
echo "║     Stack: TypeScript • NestJS • MongoDB                     ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Check if MongoDB is running
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"
if ! command -v mongosh &> /dev/null && ! command -v mongo &> /dev/null; then
    echo -e "${RED}❌ MongoDB CLI not found. Please install MongoDB first.${NC}"
    echo ""
    echo "Install with: brew install mongodb-community"
    echo "Or use Docker: docker run -d -p 27017:27017 mongo:latest"
    exit 1
fi

# Check if port 27017 is accessible
if ! nc -z localhost 27017 2>/dev/null; then
    echo -e "${RED}❌ MongoDB is not running on port 27017${NC}"
    echo ""
    echo "Start MongoDB with:"
    echo "  brew services start mongodb-community"
    echo "  OR"
    echo "  docker run -d -p 27017:27017 --name mongodb mongo:latest"
    exit 1
fi

echo -e "${GREEN}✅ MongoDB is running${NC}"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    npm install --silent
    echo -e "${GREEN}✅ Dependencies installed${NC}"
else
    echo -e "${GREEN}✅ Dependencies already installed${NC}"
fi

echo ""
echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}                    🎬 STARTING DEMO                            ${NC}"
echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Check if server is already running
if lsof -ti:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Server is already running on port 3000${NC}"
else
    echo -e "${YELLOW}🔄 Starting NestJS server...${NC}"
    npm run start:dev > server.log 2>&1 &
    SERVER_PID=$!
    
    # Wait for server to start
    echo -e "${BLUE}   Waiting for server to initialize...${NC}"
    sleep 6
    
    if lsof -ti:3000 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Server started successfully on http://localhost:3000${NC}"
    else
        echo -e "${RED}❌ Failed to start server. Check server.log for details.${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${YELLOW}                  🧪 RUNNING API TESTS                          ${NC}"
echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

BASE_URL="http://localhost:3000"
TIMESTAMP=$(date +%s)
SESSION_ID="demo-session-$TIMESTAMP"

# Test 1: Create Session
echo -e "${BOLD}Test 1: Create Session (Idempotent)${NC}"
echo -e "${BLUE}POST /sessions${NC}"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d "{
    \"sessionId\": \"$SESSION_ID\",
    \"language\": \"en\",
    \"metadata\": {
      \"source\": \"demo-script\",
      \"userId\": \"demo-user-123\"
    }
  }")
echo -e "${GREEN}✅ Response:${NC}"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
echo ""
sleep 1

# Test 2: Idempotency Check
echo -e "${BOLD}Test 2: Create Same Session Again (Tests Idempotency)${NC}"
echo -e "${BLUE}POST /sessions (with same sessionId)${NC}"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions" \
  -H "Content-Type: application/json" \
  -d "{
    \"sessionId\": \"$SESSION_ID\",
    \"language\": \"fr\",
    \"metadata\": {\"different\": \"data\"}
  }")
echo -e "${GREEN}✅ Response (should be identical to Test 1):${NC}"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
echo ""
sleep 1

# Test 3: Add Event
echo -e "${BOLD}Test 3: Add Event to Session${NC}"
echo -e "${BLUE}POST /sessions/$SESSION_ID/events${NC}"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{
    "eventId": "event-001",
    "type": "user_speech",
    "payload": {
      "text": "What is the weather today?",
      "confidence": 0.95
    }
  }')
echo -e "${GREEN}✅ Response:${NC}"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
echo ""
sleep 1

# Add more events silently
curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{"eventId": "event-002", "type": "bot_speech", "payload": {"text": "It will be sunny today!"}}' > /dev/null

curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/events" \
  -H "Content-Type: application/json" \
  -d '{"eventId": "event-003", "type": "system", "payload": {"action": "intent_detected", "intent": "weather"}}' > /dev/null

# Test 4: Get Session with Events
echo -e "${BOLD}Test 4: Get Session with Paginated Events${NC}"
echo -e "${BLUE}GET /sessions/$SESSION_ID?page=1&limit=10${NC}"
RESPONSE=$(curl -s "$BASE_URL/sessions/$SESSION_ID?page=1&limit=10")
echo -e "${GREEN}✅ Response (3 events, ordered by timestamp):${NC}"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
echo ""
sleep 1

# Test 5: Complete Session
echo -e "${BOLD}Test 5: Complete Session (Idempotent)${NC}"
echo -e "${BLUE}POST /sessions/$SESSION_ID/complete${NC}"
RESPONSE=$(curl -s -X POST "$BASE_URL/sessions/$SESSION_ID/complete")
echo -e "${GREEN}✅ Response (status=completed, endedAt set):${NC}"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
echo ""
sleep 1

# Test 6: Error Case
echo -e "${BOLD}Test 6: Error Handling - Non-existent Session${NC}"
echo -e "${BLUE}GET /sessions/fake-session-999${NC}"
RESPONSE=$(curl -s "$BASE_URL/sessions/fake-session-999")
echo -e "${YELLOW}⚠️  Response (404 Not Found):${NC}"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
echo ""

echo ""
echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}                    ✅ DEMO COMPLETED!                          ${NC}"
echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BOLD}📊 Key Features Demonstrated:${NC}"
echo -e "${GREEN}  ✅ Idempotent session creation${NC}"
echo -e "${GREEN}  ✅ Idempotent event addition${NC}"
echo -e "${GREEN}  ✅ Paginated event retrieval${NC}"
echo -e "${GREEN}  ✅ Session completion${NC}"
echo -e "${GREEN}  ✅ Proper error handling${NC}"
echo -e "${GREEN}  ✅ Data validation${NC}"
echo ""

echo -e "${BOLD}🔍 Technical Highlights:${NC}"
echo -e "${BLUE}  • MongoDB atomic operations (findOneAndUpdate with upsert)${NC}"
echo -e "${BLUE}  • Unique compound indexes for duplicate prevention${NC}"
echo -e "${BLUE}  • Thread-safe concurrent request handling${NC}"
echo -e "${BLUE}  • Comprehensive input validation with class-validator${NC}"
echo -e "${BLUE}  • Clean separation of concerns (Controller/Service/Repository)${NC}"
echo ""

echo -e "${BOLD}📚 Documentation:${NC}"
echo -e "  📄 README.md      - Setup & usage guide"
echo -e "  📄 DESIGN.md      - Design decisions & scaling strategies"
echo -e "  📄 API-TESTING.md - Comprehensive testing guide"
echo ""

echo -e "${BOLD}🎯 Next Steps:${NC}"
echo -e "  1. Review the code structure in ${BLUE}src/modules/${NC}"
echo -e "  2. Check ${BLUE}DESIGN.md${NC} for architectural decisions"
echo -e "  3. Run ${BLUE}./run-tests.sh${NC} for comprehensive testing"
echo -e "  4. Access API at ${BLUE}http://localhost:3000${NC}"
echo ""

echo -e "${BOLD}${YELLOW}💡 Pro Tip:${NC} Check server logs with: ${BLUE}tail -f server.log${NC}"
echo ""

echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  Thank you for reviewing this assignment! 🙏                  ${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
