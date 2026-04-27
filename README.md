# Site Marketing App Deployment (Azure + Terraform)

## Overview
This project deploys a containerized application to Azure using Terraform, Docker, and Azure Container Apps.

The solution follows a two-phase deployment approach to ensure reliable provisioning and avoid dependency issues between infrastructure and application layers.

---
##  Prerequisites
- Azure account
- Azure CLI
- Terraform >= 1.6
- Docker
---

##  Authentication
After creating the Service Principal, set the required credentials as environment variables:

```powershell
$env:ARM_CLIENT_ID=""
$env:ARM_CLIENT_SECRET=""
$env:ARM_TENANT_ID=""
$env:ARM_SUBSCRIPTION_ID=""
```

---
## Deployment Instructions
### 1. Clone repo

git clone "https://github.com/janagamv/site-mkt-azure-terraform-deployment-demo.git"

### 2. Phase 1 – Deploy Infrastructure

#### Configure Variables - Before Phase1

Copy the example variables file:
 copy terraform.tfvars.example terraform.tfvars
```
Add and Update required values:
 sql_admin_password = "<your-password>"
 deploy_application = false
> Note: Keep `deploy_application = false` for Phase 1 (infrastructure only)
```

#### Run Terraform to deploy the changes
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

##   Scaling

- **Min replicas: 0**  
  Enables scale-to-zero for cost optimization when there is no traffic.

- **Max replicas: 2**  
  Limits the maximum number of instances during traffic spikes.

- **HTTP-based autoscaling**  
  Scaling is automatically triggered based on incoming HTTP requests via ingress.

- **Demo consideration**  
  For demonstration purposes, `min_replicas` can be temporarily set to `1` to ensure the application is always accessible without cold-start delay.


---
##  Design Overview

- **Two-phase deployment**  
  Prevents application deployment failures when container images are not yet available in ACR.

- **Landing zone + application separation**  
  Establishes a clear separation between platform infrastructure and application deployment, enhancing scalability, reusability, and maintainability.

- **Internal backend API**  
  Backend service is not exposed publicly, enhancing security.

- **Versioned container images**  
  Uses explicit tags instead of `latest` to ensure reproducibility and consistent deployments.

- **Autoscaling configuration**  
  Enables traffic-based scaling while optimizing cost and resource usage.

---

