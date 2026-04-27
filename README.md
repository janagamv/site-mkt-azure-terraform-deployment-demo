# site-mkt-azure-terraform-deployment-demo

Site Marketing App — Azure Deployment (Terraform + Container Apps)
🔗 Live Application
Frontend URL: https://<your-site-url>
API: Internal-only (not publicly exposed)
📌 Overview

This project deploys a containerized marketing application to Azure using Terraform, Docker, and Azure Container Apps.
It follows a two-phase deployment to avoid dependency issues (images must exist in ACR before app deployment).

🏗️ Architecture
🧱 Components
Azure Resource Group
Azure Container Registry (ACR)
Azure Container Apps Environment
Azure Container Apps (Frontend & Backend)
Azure SQL Server + Database
Azure Cache for Redis
Log Analytics Workspace
🔐 Authentication

Terraform uses a Service Principal (SPN) via environment variables:

$env:ARM_CLIENT_ID=""
$env:ARM_CLIENT_SECRET=""
$env:ARM_TENANT_ID=""
$env:ARM_SUBSCRIPTION_ID=""

Secrets are not committed to source control.

⚙️ Prerequisites
Azure account (free trial works)
Azure CLI
Terraform ≥ 1.6
Docker Desktop
Git
📂 Project Structure
terraform/
  providers.tf
  variables.tf
  outputs.tf
  main.tf
  terraform.tfvars.example

  modules/
    landing_zone/
    application/

scripts/
  build-and-push.ps1
🧠 Deployment Strategy
Phase 1 — Landing Zone (Infrastructure)

Creates:

RG, ACR, Log Analytics, Container Apps Environment
SQL Server + DB, Redis
cd terraform
terraform init
terraform plan -out=phase1.tfplan
terraform apply phase1.tfplan
🐳 Build & Push Images
cd ..
./scripts/build-and-push.ps1 -acrName <your-acr-name>

Images:

site-mkt-marketing-api:v1
site-mkt-marketing-site:v1
Phase 2 — Application Deployment

Enable in terraform.tfvars:

deploy_application = true

Then:

cd terraform
terraform plan -out=phase2.tfplan
terraform apply phase2.tfplan
🌐 Access & Validation

Get URL:

terraform output site_url

Check apps:

az containerapp list -g <resource-group> -o table

View logs:

az containerapp logs show \
  --name <site-app-name> \
  --resource-group <rg> \
  --follow
⚡ Scaling
min_replicas = 0 (scale-to-zero)
max_replicas = 2
HTTP autoscaling enabled automatically via ingress

Optimized for traffic window (10 AM – 8 PM EST)

🧠 Key Design Decisions
Two-phase deployment
Prevents failures when apps reference images not yet in ACR.
Landing Zone pattern
Separates foundational infrastructure from application workloads.
Internal API
Backend is private → improved security.
Versioned images (no latest)
Ensures reproducibility and traceability.
Scale-to-zero
Reduces cost during idle periods.
🔐 Secrets Handling
SQL password marked sensitive
Not committed to repo
Passed via:
$env:TF_VAR_sql_admin_password="..."
⚠️ Known Limitations
AzureRM provider doesn’t expose HTTP scaling rule config (concurrency)
Redis provisioning may be slow on free tier/regions
Revision-specific FQDN avoided to prevent Terraform drift
🚀 Future Improvements
Azure Key Vault for secrets
Managed Identity / OIDC (no client secrets)
CI/CD pipeline (GitHub Actions / Azure DevOps)
Private endpoints for SQL/Redis
WAF (Front Door / App Gateway)
Application Insights
💬 Summary

This solution demonstrates:

Infrastructure as Code (Terraform)
Cloud-native deployment (Container Apps)
Secure architecture (internal API, no secrets in code)
Cost optimization (scale-to-zero)
Clean separation of concerns (landing zone vs application)
🧪 Local Testing
docker compose up --build

Open:

http://localhost:8881
⚠️ Troubleshooting
Ensure images are pushed before Phase 2
Use terraform import if resources partially exist
Redis creation may take 20–30 mins on free tier
✅ Submission Notes
Code is fully reproducible via Terraform
No secrets included
Application deployed and validated successfully
