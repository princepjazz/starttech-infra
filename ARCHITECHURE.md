

# System Architecture

## Overview

The application uses a cloud-native architecture deployed on AWS.

---

# High-Level Architecture

Users → CloudFront → S3 Frontend

Users → ALB → EC2 Auto Scaling Group → Golang API

API → MongoDB Atlas

API → Redis ElastiCache

Logs → CloudWatch

---

# Components

## Frontend Layer

- React application
- Hosted on S3
- Distributed through CloudFront CDN

## Backend Layer

- Golang REST API
- Dockerized application
- Running on EC2 Auto Scaling Group

## Networking

- VPC
- Public Subnets
- Security Groups
- Internet Gateway

## Load Balancing

- Application Load Balancer
- Health checks enabled

## Caching

- Redis ElastiCache cluster

## Database

- MongoDB Atlas cluster

## Monitoring

- CloudWatch Logs
- CloudWatch Metrics
- CloudWatch Alarms

---

# CI/CD Flow

Developer Push → GitHub Actions

Frontend:
Build → Test → Security Scan → Deploy to S3

Backend:
Test → Docker Build → Vulnerability Scan → Push to ECR → Deploy to EC2

Infrastructure:
Terraform Validate → Plan → Apply

---

# Security Design

- IAM least privilege
- Private backend communication
- GitHub Secrets
- Docker image scanning
- Terraform security scanning

---

# Scalability

- Auto Scaling Group
- Load balancing
- CloudFront edge caching
- Redis caching

---

# Availability

- Multi-AZ deployment
- Health checks
- Rolling deployments
