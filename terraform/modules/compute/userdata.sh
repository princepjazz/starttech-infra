#!/bin/bash
set -e
# Install Docker
curl -fsSL https://get.docker.com | sh
systemctl start docker
systemctl enable docker

# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb

# Login to ECR and pull the backend image
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ecr_registry}
docker pull ${ecr_registry}/starttech-backend:${image_tag}

# Run the container
docker run -d \
  -p 8080:8080 \
  -e MONGO_URI="${mongo_uri}" \
  -e REDIS_URL="${redis_url}" \
  --log-driver=awslogs \
  --log-opt awslogs-region=us-east-1 \
  --log-opt awslogs-group=/starttech/backend \
  --restart always \
  ${ecr_registry}/starttech-backend:${image_tag}
