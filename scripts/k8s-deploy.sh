#!/bin/bash

# Script to deploy MuchTodo application to Kubernetes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Deploying MuchTodo to Kubernetes ===${NC}"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed. Please install kubectl first.${NC}"
    exit 1
fi

# Check if kind is installed (for local cluster)
if ! command -v kind &> /dev/null; then
    echo -e "${YELLOW}Warning: kind is not installed. This script is designed for local Kind clusters.${NC}"
    echo -e "${YELLOW}You can install kind from: https://kind.sigs.k8s.io/docs/user/quick-start/${NC}"
fi

# Build Docker image first
echo -e "${YELLOW}Step 1: Building Docker image...${NC}"

./scripts/docker-build.sh

# Load image into kind if using kind
if command -v kind &> /dev/null && kind get clusters | grep -q "kind"; then
    echo -e "${YELLOW}Step 2: Loading image into Kind cluster...${NC}"
    kind load docker-image muchtodo-backend:latest
fi

# Apply Kubernetes manifests
echo -e "${YELLOW}Step 3: Applying Kubernetes manifests...${NC}"
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/ingress.yaml

# Wait for deployments to be ready
echo -e "${YELLOW}Step 4: Waiting for deployments to be ready...${NC}"
kubectl wait --namespace=muchtodo --for=condition=available --timeout=300s deployment/mongodb
kubectl wait --namespace=muchtodo --for=condition=available --timeout=300s deployment/muchtodo-backend

# Show deployment status
echo -e "\n${GREEN}=== Deployment Status ===${NC}"
kubectl get all -n muchtodo

# Show ingress information
echo -e "\n${YELLOW}Ingress Information:${NC}"
kubectl get ingress -n muchtodo

# Get service information
echo -e "\n${YELLOW}To access the application:${NC}"
echo -e "1. If using NodePort, check port with: ${BLUE}kubectl get svc -n muchtodo${NC}"
echo -e "2. If using Ingress, add to /etc/hosts: ${BLUE}127.0.0.1 muchtodo.local${NC}"
echo -e "3. Health check: ${BLUE}http://localhost:8080/health${NC} (or via Ingress)"
echo -e "\nTo view logs: ${BLUE}kubectl logs -f deployment/muchtodo-backend -n muchtodo${NC}"
echo -e "To cleanup: ${BLUE}./scripts/k8s-cleanup.sh${NC}"
