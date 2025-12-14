#!/bin/bash

# Script to cleanup Kubernetes resources for MuchTodo application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Cleaning up MuchTodo Kubernetes Resources ===${NC}"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed.${NC}"
    exit 1
fi

# Confirm deletion
read -p "Are you sure you want to delete all MuchTodo Kubernetes resources? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
    exit 0
fi

# Delete resources
echo -e "${YELLOW}Deleting resources...${NC}"

# Delete in reverse order of creation
kubectl delete -f kubernetes/ingress.yaml 2>/dev/null || true
kubectl delete -f kubernetes/backend/ 2>/dev/null || true
kubectl delete -f kubernetes/mongodb/ 2>/dev/null || true
kubectl delete -f kubernetes/namespace.yaml 2>/dev/null || true

# Wait a bit for resources to be deleted
sleep 5

# Check if any resources remain
echo -e "\n${YELLOW}Checking for remaining resources...${NC}"
RESOURCES=$(kubectl get all -n muchtodo 2>/dev/null | grep -v "No resources found" | wc -l)

if [ "$RESOURCES" -gt 0 ]; then
    echo -e "${YELLOW}Some resources still exist in muchtodo namespace. Deleting namespace...${NC}"
    kubectl delete namespace muchtodo --timeout=60s 2>/dev/null || true
fi

# Final check
if kubectl get namespace muchtodo 2>/dev/null; then
    echo -e "${YELLOW}Namespace still exists, forcing deletion...${NC}"
    kubectl delete namespace muchtodo --force --grace-period=0 2>/dev/null || true
fi

echo -e "\n${GREEN}✓ Cleanup completed successfully${NC}"
echo -e "All MuchTodo Kubernetes resources have been removed."
