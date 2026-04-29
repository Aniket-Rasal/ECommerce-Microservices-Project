# E-Commerce DevOps Project

A production-grade DevOps implementation of a 3-tier microservices e-commerce backend.

## Architecture

<img width="1440" height="1240" alt="image" src="https://github.com/user-attachments/assets/7513f1b1-b9f5-4981-8342-e4045eaaa11c" />


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
Challenges you hit and what they teach interviewers
1. Docker DNS on VirtualBox
Your VM couldn't pull images from Docker Hub. You fixed it by setting 8.8.8.8 in /etc/docker/daemon.json.
What it teaches: Networking in containerized environments isn't automatic. DNS resolution differs between host, container, and Kubernetes — understanding layers matters.

2. Nginx upstream DNS resolution
Gateway crashed because Nginx resolves upstreams at startup — if a service isn't ready, Nginx fails hard. Fixed with resolver 127.0.0.11 and dynamic $upstream variables.
What it teaches: Service startup order and dependency management is a real production problem. Kubernetes readiness probes exist for exactly this reason.

3. EKS version + AMI compatibility
K8s 1.29 AMI was unsupported. Skipping versions (1.29 → 1.32) also failed. Required destroy and fresh apply at 1.32.
What it teaches: Cloud managed services deprecate versions fast. Pinning versions in IaC and staying current is operational discipline.

4. Terraform single-line variable syntax
{ type = string default = "value" } fails — Terraform requires multi-line for multiple arguments.
What it teaches: IaC has strict syntax rules. Small formatting errors break entire deployments. Code review and terraform validate catch these before apply.

5. t3.micro pod limits on EKS
AWS limits pods per node based on network interfaces. A single t3.micro maxed out at 4 pods — system pods consumed most slots, leaving no room for your services.
What it teaches: Instance sizing in Kubernetes isn't just about CPU/RAM — ENI limits are a real constraint. This is a common interview question.

6. PostgreSQL reserved username
admin is reserved in PostgreSQL — RDS rejected it. Changed to dbadmin.
What it teaches: Read the docs before naming things. Reserved words in databases cause subtle failures that aren't obvious until runtime.

7. Rolling deployment deadlock
maxUnavailable: 0 + a node at capacity = new pods can't start, old pods won't terminate. Deadlock.
What it teaches: Rolling update strategy must be tuned to your cluster capacity. In production, always have headroom — at least 1 spare pod slot per node.

8. VM clock drift breaking AWS signatures
AWS request signing uses timestamps — a drifted VM clock caused SignatureDoesNotMatch errors across Terraform and kubectl.
What it teaches: Time synchronization is infrastructure. NTP misconfiguration breaks security-sensitive APIs silently
9. Resolved ConfigMap missing issue causing pod startup failure
10. Debugged AWS CNI IP exhaustion problem  
12. Fixed 502 Bad Gateway due to Nginx misconfiguration  
13. Handled Kubernetes scheduling limits due to node capacity  
