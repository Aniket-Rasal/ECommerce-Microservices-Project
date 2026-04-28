# E-Commerce DevOps Project

A production-grade DevOps implementation of a 3-tier microservices e-commerce backend.

## Architecture

GitHub → GitHub Actions CI/CD
              ↓
           AWS ECR
              ↓
         EKS Cluster
         ┌────────────────────────┐
         │  Nginx Gateway (LB)    │
         │  ↙              ↘     │
         │ user-service  product-service │
         │       ↘        ↙      │
         │      RDS PostgreSQL    │
         └────────────────────────┘
              ↑
           Terraform (VPC, EKS, RDS)
              ↑
         S3 Remote State

## Tech Stack

| Layer | Tool |
|---|---|
| Source Control | GitHub |
| CI/CD | GitHub Actions |
| Containers | Docker (multi-stage builds) |
| Registry | AWS ECR |
| Infrastructure | Terraform |
| Orchestration | AWS EKS (Kubernetes 1.32) |
| Database | AWS RDS PostgreSQL 16 |
| Security | Trivy image scanning + Snyk |
| Secrets | Kubernetes Secrets |

## Services

- **User Service** — Node.js + Express (port 3000)
- **Product Service** — Python + FastAPI (port 8000)
- **API Gateway** — Nginx reverse proxy (port 80)

## Project Structure
ecommerce-devops/
├── user-service/          # Node.js API
├── product-service/       # Python FastAPI
├── gateway/               # Nginx config
├── infra/
│   ├── terraform/         # IaC - VPC, EKS, RDS
│   └── k8s/               # Kubernetes manifests
├── .github/workflows/     # CI/CD pipelines
└── docs/                  # Architecture diagram
## CI/CD Pipeline

Every push to `main` triggers:
1. Lint & test both services in parallel
2. Trivy security scan — blocks on critical CVEs
3. Build Docker images with git SHA tag
4. Push to AWS ECR
5. Rolling deploy to EKS

## Local Development

```bash
docker compose up --build
curl http://localhost/health
curl http://localhost/users
curl http://localhost/products
```

## Infrastructure

```bash
cd infra/terraform/environments/dev
terraform init
terraform plan -var="db_password=YOUR_PASSWORD" -var="db_username=dbadmin"
terraform apply -var="db_password=YOUR_PASSWORD" -var="db_username=dbadmin"
```

## Deploy to Kubernetes

```bash
kubectl apply -f infra/k8s/configmaps/
kubectl apply -f infra/k8s/secrets/
kubectl apply -f infra/k8s/gateway/
kubectl apply -f infra/k8s/user-service/
kubectl apply -f infra/k8s/product-service/
```

## Verify Deployment

```bash
kubectl get pods
kubectl get svc gateway
curl http://GATEWAY_URL/health
```
## ⚠️ Challenges & Learnings

- Resolved ConfigMap missing issue causing pod startup failure  
- Debugged AWS CNI IP exhaustion problem  
- Fixed 502 Bad Gateway due to Nginx misconfiguration  
- Handled Kubernetes scheduling limits due to node capacity  
