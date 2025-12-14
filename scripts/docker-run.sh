#!/bin/bash

# Script to run MuchTodo application using docker-compose

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Starting MuchTodo Application ===${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}docker-compose not found, trying docker compose...${NC}"
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

# Start the services
echo -e "${YELLOW}Starting services...${NC}"

$COMPOSE_CMD up -d

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Services started successfully${NC}"
    
    # Show running containers
    echo -e "\n${YELLOW}Running containers:${NC}"
    $COMPOSE_CMD ps
    
    # Show logs
    echo -e "\n${YELLOW}Application logs (Ctrl+C to stop viewing logs):${NC}"
    echo -e "To view logs anytime, run: ${YELLOW}$COMPOSE_CMD logs -f${NC}"
    
    echo -e "\n${GREEN}=== Application Information ===${NC}"
    echo -e "Backend API: ${YELLOW}http://localhost:8080${NC}"
    echo -e "Health check: ${YELLOW}http://localhost:8080/health${NC}"
    echo -e "API Documentation: ${YELLOW}http://localhost:8080/swagger/index.html${NC}"
    echo -e "\nTo stop the application, run: ${YELLOW}./scripts/k8s-cleanup.sh${NC} (for k8s) or ${YELLOW}$COMPOSE_CMD down${NC} (for docker-compose)"
else
    echo -e "${RED}✗ Failed to start services${NC}"
    exit 1
fi
