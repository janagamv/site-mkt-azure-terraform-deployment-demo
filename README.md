# 🚀 Site Marketing App Deployment (Azure + Terraform)

## 📌 Overview
This project deploys a containerized application to Azure using Terraform, Docker, and Azure Container Apps.

The solution follows a two-phase deployment approach to ensure reliable provisioning and avoid dependency issues between infrastructure and application layers.

---

## 🧱 Architecture
- Frontend: Azure Container App (public)
- Backend API: Azure Container App (internal)
- Database: Azure SQL Database
- Cache: Azure Redis
- Images: Azure Container Registry

---

## ⚙️ Prerequisites
- Azure account
- Azure CLI
- Terraform >= 1.6
- Docker

---

## 🔐 Authentication
Set Service Principal credentials:

```powershell
$env:ARM_CLIENT_ID=""
$env:ARM_CLIENT_SECRET=""
$env:ARM_TENANT_ID=""
$env:ARM_SUBSCRIPTION_ID=""
