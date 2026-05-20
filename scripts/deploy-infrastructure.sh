

#!/bin/bash
set -euo pipefail

echo "==> Initializing Terraform..."
cd terraform
terraform init

echo "==> Planning..."
terraform plan -out=tfplan -var-file=terraform.tfvars

echo "==> Applying..."
terraform apply -auto-approve tfplan

echo "==> Outputs:"
terraform output
