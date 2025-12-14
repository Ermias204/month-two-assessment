# MuchTodo Application - Containerization Assessment

This repository contains the containerized deployment setup for the MuchTodo backend application, a Golang API with MongoDB database.

## Project Structure

container-assessment/
├── Server/ # Original application code
│ └── MuchToDo/ # Go application
│ ├── cmd/api/main.go # Application entry point
│ ├── internal/ # Internal packages
│ ├── go.mod # Go dependencies
│ └── .env.example # Environment template
├── Dockerfile # Multi-stage Dockerfile
├── docker-compose.yml # Local development setup
├── .dockerignore # Docker ignore patterns
├── kubernetes/ # Kubernetes manifests
│ ├── namespace.yaml # Namespace definition
│ ├── mongodb/ # MongoDB resources
│ ├── backend/ # Backend application resources
│ └── ingress.yaml # Ingress configuration
├── scripts/ # Automation scripts
│ ├── docker-build.sh # Build Docker image
│ ├── docker-run.sh # Run with docker-compose
│ ├── k8s-deploy.sh # Deploy to Kubernetes
│ └── k8s-cleanup.sh # Cleanup Kubernetes resources
└── evidence/ # Screenshots for assessment

## Prerequisites

1. **Docker** and **Docker Compose**
2. **Kubernetes CLI (kubectl)**
3. **Kind** (for local Kubernetes cluster)
4. **Go 1.25+** (for local development)

## Phase 1: Docker Setup

### Building the Docker Image

# Build the Docker image

./scripts/docker-build.sh

# Or manually:

docker build -t muchtodo-backend:latest .

# Start the application with MongoDB

./scripts/docker-run.sh

# Or manually:

docker-compose up -d

# Check running containers

docker-compose ps

# View logs

docker-compose logs -f

# Stop the application

docker-compose down

## Accessing the Application

Backend API: http://localhost:8080

Health Check: http://localhost:8080/health

Swagger Docs: http://localhost:8080/swagger/index.html

MongoDB: localhost:27017

## Phase 2: Kubernetes Deployment

### Setting up Kind Cluster

# Create a Kind cluster

kind create cluster --name muchtodo-cluster

# Verify cluster

kubectl cluster-info --context kind-muchtodo-cluster

## Deploying to Kubernetes

# Build and deploy everything

./scripts/k8s-deploy.sh

# Or deploy manually:

# 1. Create namespace

kubectl apply -f kubernetes/namespace.yaml

# 2. Deploy MongoDB

kubectl apply -f kubernetes/mongodb/

# 3. Deploy Backend

kubectl apply -f kubernetes/backend/

# 4. Deploy Ingress

kubectl apply -f kubernetes/ingress.yaml

## Accessing the Kubernetes Deployment

1: Using Ingress

Add to /etc/hosts:
127.0.0.1 muchtodo.local

## Access the application:

http://muchtodo.local

http://muchtodo.local/health

http://muchtodo.local/swagger

## Monitoring and Management

## Check all resources

kubectl get all -n muchtodo

# View pod logs

kubectl logs -f deployment/muchtodo-backend -n muchtodo

# View pod details

kubectl describe pod -n muchtodo -l app=muchtodo-backend

# Check persistent volumes

kubectl get pvc -n muchtodo

## Cleaning Up

# Cleanup Kubernetes resources

./scripts/k8s-cleanup.sh

# Or manually:

kubectl delete -f kubernetes/ingress.yaml
kubectl delete -f kubernetes/backend/
kubectl delete -f kubernetes/mongodb/
kubectl delete -f kubernetes/namespace.yaml

# Delete Kind cluster

kind delete cluster --name muchtodo-cluster

## Environment Variables

The application requires the following environment variables (configured in docker-compose.yml and Kubernetes manifests):

Variable Description Default
PORT Application port 8080
MONGO_URI MongoDB connection string mongodb://admin:secret123@mongodb:27017/much_todo_db
DB_NAME Database name much_todo_db
JWT_SECRET_KEY JWT signing key your-super-secret-key
JWT_EXPIRATION_HOURS JWT expiration time 72
LOG_LEVEL Logging level DEBUG
LOG_FORMAT Log format (json/text) json
ENABLE_CACHE Enable Redis cache false

## Health Checks

Docker: HEALTHCHECK directive in Dockerfile

Docker Compose: Health check in docker-compose.yml

Kubernetes: Readiness and liveness probes in deployment manifests

## Security Features

Non-root user: Application runs as non-root user in container

Secrets management: Sensitive data stored in Kubernetes Secrets

Resource limits: CPU and memory limits in Kubernetes deployments

Network policies: Services use ClusterIP for internal communication

Health checks: Comprehensive health monitoring

## Debug Commands

# Docker

docker ps -a
docker logs <container_id>
docker exec -it <container_id> sh

# Kubernetes

kubectl get events -n muchtodo
kubectl describe pod <pod_name> -n muchtodo
kubectl logs <pod_name> -n muchtodo --previous


## Assessment Evidence
### See the evidence/ directory for required screenshots:

Docker build process completion

Docker compose running successfully

Application responding via docker-compose

Kind cluster creation

Kubernetes deployments running

Application accessible through NodePort/Ingress

Kubectl commands showing pod status, services, and ingress