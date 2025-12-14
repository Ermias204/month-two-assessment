This directory contains Kubernetes manifests for deploying the MuchTodo application.

## Structure

- `namespace.yaml`: Creates the dedicated namespace
- `mongodb/`: MongoDB database deployment
  - `mongodb-secret.yaml`: Database credentials
  - `mongodb-configmap.yaml`: MongoDB configuration
  - `mongodb-pvc.yaml`: Persistent volume claim for data
  - `mongodb-deployment.yaml`: MongoDB deployment
  - `mongodb-service.yaml`: MongoDB service
- `backend/`: Backend application deployment
  - `backend-secret.yaml`: Application secrets
  - `backend-configmap.yaml`: Application configuration
  - `backend-deployment.yaml`: Backend deployment
  - `backend-service.yaml`: Backend service
- `ingress.yaml`: Ingress configuration for external access

## Deployment Order

1. namespace.yaml
2. mongodb/ (all files)
3. backend/ (all files)
4. ingress.yaml

## Quick Deployment

Use the provided scripts:

```bash
# Build and deploy
./scripts/k8s-deploy.sh

# Cleanup
./scripts/k8s-cleanup.sh
```
