#This can be case sensitive and should be part of key vault in future
sql_admin_password = "Enter your sql admin password"

# Phase 1: keep false
# Phase 2: change to true after images are pushed to ACR
deploy_application = true

#Image urls
api_image  = "acrsitemktdevcac.azurecr.io/site-mkt-marketing-api:v1"
site_image = "acrsitemktdevcac.azurecr.io/site-mkt-marketing-site:v1"