
# Next.js Dockerized Application with Kubernetes Deployment

This repository contains a simple Next.js application containerized with Docker, automated build and push to GitHub Container Registry (GHCR) using GitHub Actions, and deployed to a local Kubernetes cluster using Minikube.

---

## Table of Contents

- [Project Overview](#project-overview)  
- [Setup Instructions](#setup-instructions)  
- [Local Development](#local-development)  
- [Docker Containerization](#docker-containerization)  
- [GitHub Actions CI/CD](#github-actions-cicd)  
- [Kubernetes Deployment on Minikube](#kubernetes-deployment-on-minikube)  
- [Accessing the Application](#accessing-the-application)  
- [Troubleshooting](#troubleshooting)

---

## Project Overview

- Create a Next.js application as the web app.  
- Dockerize the app using a multi-stage Dockerfile for optimized builds.  
- Automatically build and push Docker images to GHCR using GitHub Actions on push to `main`.  
- Deploy the container image to a local Minikube Kubernetes cluster using manifests.

---

## Setup Instructions

### Prerequisites

- Node.js and npm installed.  
- Docker installed.  
- Minikube installed and running.  
- kubectl installed and configured.  
- GitHub repository created (public) with this code.  
- GitHub Actions enabled on repository.

---

## Local Development

Clone the repository:

```
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>

```

Install dependencies:

```
npm install

```
Run the Next.js app locally:

```
npm run dev

```
This starts the server at:  
`http://localhost:3000`

---

## Docker Containerization

The project contains a `Dockerfile` that builds the Next.js app using multi-stage builds.

### Build Docker Image Locally

To build the Docker image locally:

```
docker build -t my-nextjs-app .

```
Run the container:

```
docker run -p 3000:3000 my-nextjs-app

```
Access the app at:  
`http://localhost:3000`

---

## GitHub Actions CI/CD

GitHub Actions workflow (`.github/workflows/docker-ghcr.yml`) automatically:

- Builds the Docker image on every push to `main`.  
- Logs in to GitHub Container Registry (GHCR).  
- Pushes the image to GHCR with tag `latest`.

### Key workflow parts:

- Uses built-in `GITHUB_TOKEN` with permissions:  
```
permissions:
contents: read
packages: write

```
- Tags image as `ghcr.io/<github-username>/my-nextjs-app:latest`.
---

## Kubernetes Deployment on Minikube

### Step 1: Use Minikube's Docker daemon

Switch Docker CLI to Minikube's Docker environment:

```
eval \$(minikube docker-env)
```

### Step 2: Build Docker image inside Minikube

```
docker build -t next-app:latest .
```

### Step 3: Apply Kubernetes manifests
Manifests are located in the `k8s-manifests` directory
Apply deployment and service:

```
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### Step 4: Verify pods and services

```
kubectl get pods
kubectl get svc
```

---

## Accessing the Application

The Kubernetes service is exposed as a NodePort (`30080`).
Access the app via Minikube's IP or localhost with the port:

```
minikube service nextjs-service
```

Or directly open:

```
http://localhost:30080

```

---

## Troubleshooting

- **ImagePullBackOff error:**  
  Make sure Docker image is built inside Minikube environment and `imagePullPolicy` is set to `IfNotPresent` in `deployment.yaml`.

- **GHCR push permission denied:**  
  Add the following permissions in GitHub Actions workflow:  
```
permissions:
packages: write
contents: read

```
---

## Summary of Commands

```
# Clone repo

git clone https://github.com/<username>/<repo>.git
cd <repo>

# Local development

npm install
npm run dev

# Build Docker image locally

docker build -t my-nextjs-app .
docker run -p 3000:3000 my-nextjs-app

# Minikube Docker environment switch
eval \$(minikube docker-env)

# Build Docker image in Minikube
docker build -t next-app:latest .

# Deploy to Kubernetes
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Access the app
minikube service nextjs-service
```
---

