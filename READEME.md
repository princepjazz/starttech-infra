

# StartTech CI/CD Infrastructure Project

## Overview

This project implements a complete production-grade CI/CD pipeline for a full-stack application using AWS, Terraform, Docker, and GitHub Actions.

## Technologies Used

- Terraform
- AWS
- Docker
- GitHub Actions
- React
- Golang
- MongoDB Atlas
- Redis
- CloudWatch

---

## Architecture

### Frontend
- React application hosted on S3
- Delivered globally using CloudFront

### Backend
- Golang API running on EC2 Auto Scaling Group
- Application Load Balancer

### Database
- MongoDB Atlas

### Cache
- Redis ElastiCache

---

## Repository Structure

```bash
starttech-infra/
starttech-application/
```

---

## Setup Instructions

### Clone Repository

```bash
git clone <repo-url>
```

### Configure AWS CLI

```bash
aws configure
```

### Terraform Deployment

```bash
cd terraform
terraform init
terraform apply
```

---

## GitHub Secrets

The following secrets are required:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
- ECR_REPOSITORY
- S3_BUCKET_NAME
- CLOUDFRONT_DISTRIBUTION_ID

---

## CI/CD Pipelines

### Frontend Pipeline
- Build React app
- Run tests
- Deploy to S3
- Invalidate CloudFront

### Backend Pipeline
- Run Go tests
- Build Docker image
- Push to ECR
- Deploy to EC2

---

## Monitoring

- CloudWatch Logs
- CloudWatch Metrics
- Log Insights Queries

---

## Security

- IAM least privilege
- Security group restrictions
- Vulnerability scanning
- GitHub secrets management

---

## Deployment

### Infrastructure

```bash
terraform apply
```

### Frontend

```bash
git push origin main
```

### Backend

```bash
git push origin main
```

---

## Rollback

Rollback scripts are located in:

```bash
scripts/rollback.sh
```

---

## Author

StartTech DevOps Assessment
