


# Operations Runbook

## Service Health Checks

### Backend API

```bash
curl http://<alb-dns>/health
```

Expected Response:

```json
{
  "status": "ok"
}
```

---

## Restart Backend Service

SSH into EC2:

```bash
sudo systemctl restart starttech-api
```

---

## Check Docker Containers

```bash
docker ps
```

---

## Check Application Logs

### CloudWatch Logs

Navigate to:

AWS Console → CloudWatch → Log Groups

### EC2 Local Logs

```bash
docker logs <container-id>
```

---

## Rollback Deployment

```bash
./scripts/rollback.sh
```

---

## Common Issues

### Application Not Reachable

Check:
- ALB target health
- Security groups
- EC2 instance status

### Frontend Not Updating

Run CloudFront invalidation:

```bash
aws cloudfront create-invalidation \
--distribution-id <distribution-id> \
--paths "/*"
```

### Docker Deployment Failed

Check:
- ECR authentication
- Docker daemon
- Image availability

---

## Monitoring

### CloudWatch Metrics

Monitor:
- CPU Utilization
- Memory Usage
- ALB 5xx Errors
- Request Count

---

## Scaling Operations

### Increase ASG Capacity

```bash
aws autoscaling update-auto-scaling-group \
--auto-scaling-group-name backend-asg \
--desired-capacity 3
```

---

## Emergency Recovery

1. Rollback deployment
2. Check CloudWatch logs
3. Verify EC2 health
4. Restart services
5. Re-deploy stable image
