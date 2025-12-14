# Evidence Directory

This directory should contain screenshots for the assessment evidence:

## Required Screenshots:

1. **Docker Build Process Completion**
   - Screenshot of successful `docker build` command
   - Show the final image being created

2. **Docker Compose Running Successfully**
   - Screenshot of `docker-compose ps` showing both containers running
   - Show containers in healthy state

3. **Application Responding via Docker Compose**
   - Screenshot of accessing `http://localhost:8080/health`
   - Screenshot of accessing `http://localhost:8080/swagger/index.html`

4. **Kind Cluster Creation**
   - Screenshot of `kind create cluster` command
   - Screenshot of `kubectl cluster-info`

5. **Kubernetes Deployments Running**
   - Screenshot of `kubectl get all -n muchtodo`
   - Screenshot of `kubectl get pods -n muchtodo` showing pods Running

6. **Application Accessible through NodePort/Ingress**
   - Screenshot of accessing via NodePort
   - Screenshot of accessing via Ingress (if configured)

7. **Kubectl Commands Showing Status**
   - Screenshot of `kubectl get services -n muchtodo`
   - Screenshot of `kubectl get ingress -n muchtodo`
   - Screenshot of `kubectl describe pod <pod-name> -n muchtodo`
