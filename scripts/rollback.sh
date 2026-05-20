

#!/bin/bash
set -e
PREV_TAG=$1
ECR_REGISTRY=$2

echo "==> Rolling back to image: $PREV_TAG"
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name starttech-asg \
  --preferences '{"MinHealthyPercentage":50}'

echo "Rollback initiated. Monitor in AWS Console."
