#!/bin/bash

# Script to build Docker images for MuchTodo application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Building MuchTodo Docker Images ===${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Build the backend image
echo -e "${YELLOW}Building backend image...${NC}"
docker build -t muchtodo-backend:latest .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend image built successfully${NC}"
else
    echo -e "${RED}✗ Failed to build backend image${NC}"
    exit 1
fi

# List the built image
echo -e "\n${YELLOW}Built Docker images:${NC}"
docker images | grep muchtodo-backend

echo -e "\n${GREEN}=== Build Complete ===${NC}"
echo -e "To run the application, use: ${YELLOW}./scripts/docker-run.sh${NC}"
