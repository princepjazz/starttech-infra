

#!/bin/bash
ALB_DNS=$1
MAX_RETRIES=10
COUNT=0

until curl -sf "http://$ALB_DNS/health"; do
  COUNT=$((COUNT+1))
  [ $COUNT -ge $MAX_RETRIES ] && echo "Health check failed" && exit 1
  echo "Waiting... ($COUNT/$MAX_RETRIES)"
  sleep 10
done
echo "Health check passed!"
