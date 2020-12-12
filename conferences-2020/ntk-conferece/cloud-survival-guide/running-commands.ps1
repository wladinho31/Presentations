# Connect to Azure (PowerShell)
Connect-AzAccount -UseDeviceAuthentication
Select-AzSubscription -SubscriptionId "<add-your-desired-subscription-id>"

# Deploy an ARM template using PowerShell
New-AzResourceGroupDeployment -Name "ntk2020-windows" -ResourceGroupName ntk2020-rg -TemplateFile .\windows-server-arm.json -WhatIf
New-AzResourceGroupDeployment -Name "ntk2020-windows" -ResourceGroupName ntk2020-rg -TemplateFile .\windows-server-arm.json

# Connect to Azure (Az CLI)
az login --use-device-code
az account set --subscription "<add-your-desired-subscription-id-or-name>"

# Run Terraform commands
terraform init
terraform validate
terraform plan -out "ntk2020linux.tfplan"
terraform apply "ntk2020linux.tfplan"