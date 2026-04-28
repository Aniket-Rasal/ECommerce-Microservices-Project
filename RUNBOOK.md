# Operational Runbook

## How to Rollback a Bad Deployment

### Option 1 — Kubernetes Rollback
```bash
# Check rollout history
kubectl rollout history deployment/user-service

# Rollback to previous version
kubectl rollout undo deployment/user-service

# Verify rollback
kubectl rollout status deployment/user-service
kubectl get pods
```

### Option 2 — Deploy Specific Image Tag
```bash
# List available tags in ECR
aws ecr list-images --repository-name ecommerce/user-service

# Update deployment with specific tag
kubectl set image deployment/user-service \
  user-service=831635639723.dkr.ecr.us-east-1.amazonaws.com/ecommerce/user-service:GIT_SHA
```

## How to Check Service Health

```bash
# Pod status
kubectl get pods

# Pod logs
kubectl logs -f deployment/user-service
kubectl logs -f deployment/product-service

# Describe pod for events
kubectl describe pod POD_NAME
```

## How to Scale Services

```bash
# Manual scale
kubectl scale deployment/product-service --replicas=3

# Check HPA status
kubectl get hpa
```

## How to Rotate Database Password

```bash
# Update secret
kubectl create secret generic app-secrets \
  --from-literal=DB_USER=dbadmin \
  --from-literal=DB_PASSWORD=NEW_PASSWORD \
  --dry-run=client -o yaml | kubectl apply -f -

# Restart pods to pick up new secret
kubectl rollout restart deployment/user-service
kubectl rollout restart deployment/product-service
```

## Cost Management

```bash
# Destroy all AWS resources when not in use
cd infra/terraform/environments/dev
terraform destroy -var="db_password=YOUR_PASSWORD" -var="db_username=dbadmin"
```
