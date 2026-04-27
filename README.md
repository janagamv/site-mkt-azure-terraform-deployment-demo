# Site Marketing App Deployment (Azure + Terraform)

## Overview
This project deploys a containerized application to Azure using Terraform, Docker, and Azure Container Apps.

The solution follows a two-phase deployment approach to ensure reliable provisioning and avoid dependency issues between infrastructure and application layers.

---

## ⚙️ Prerequisites
- Azure account
- Azure CLI
- Terraform >= 1.6
- Docker

---

## 🔐 Authentication
Set Service Principal credentials once you have provisioned your service principal:

powershell
$env:ARM_CLIENT_ID=""
$env:ARM_CLIENT_SECRET=""
$env:ARM_TENANT_ID=""
$env:ARM_SUBSCRIPTION_ID=""

---
## Deployment Instructions
### 1. Clone repo

git clone "https://github.com/janagamv/site-mkt-azure-terraform-deployment-demo.git"

### 2. Phase 1 – Deploy Infrastructure

#### Configure Variables - Before Phase1

Copy the example variables file:
 copy terraform.tfvars.example terraform.tfvars
Add and Update required values:
 sql_admin_password = "<your-password>"
 deploy_application = false
 
> Note: Keep `deploy_application = false` for Phase 1 (infrastructure only)

#### Run Terraform to deploy the3 changes
```
terraform init
terraform plan -out=phase1tfplan
terraform apply phase1tfplan

```
### 3. Build & Push Docker Images
Note: Assuming you have all the docker files https://github.com/RXNT/site-mkt
#### You can get the acr name from terraform outputs
```
az acr login --name <acr-name>
docker build -t <acr-name>.azurecr.io/site-mkt-marketing-api:v1 -f Dockerfile.api .
docker build -t <acr-name>.azurecr.io/site-mkt-marketing-site:v1 -f Dockerfile.site .

docker push <acr-name>.azurecr.io/site-mkt-marketing-api:v1
docker push <acr-name>.azurecr.io/site-mkt-marketing-site:v1
```
### 4. Phase 2 – Deploy Application

#### Update Variables for Application Deployment before Phase 2

After pushing Docker images, update `terraform.tfvars`:
```
deploy_application = true

api_image = "<acr-name>.azurecr.io/site-mkt-marketing-api:v1"
site_image = "<acr-name>.azurecr.io/site-mkt-marketing-site:v1"

```
#### Run Terraform to deploy application
```
terraform plan -out=phase2tfplan
terraform apply phase2tfplan
```
#### Access Application
```
terraform output site_url
```

## Scaling
Min replicas: 1 (for demo reliability)
Max replicas: 2
HTTP scaling enabled automatically via ingress

---

---
## Design Overview
Two-phase deployment
Avoids failures when Container Apps reference images not yet in ACR.
Landing zone + application separation
Improves modularity and reusability.
Internal backend API
Backend is not publicly exposed for better security.
Versioned container images
Ensures reproducibility and avoids latest issues.
Autoscaling configuration
Supports traffic-based scaling with cost optimization.

---
## Secrets Handling
No secrets committed to repository
SQL password passed via environment variable:
$env:TF_VAR_sql_admin_password="..."

