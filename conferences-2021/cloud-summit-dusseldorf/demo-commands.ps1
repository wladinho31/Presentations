#region powershell-example
# Variables
$location         = "westeurope"
$resourceGroup    = "cloudsummit-rg"
$vNetName         = "cloudsummit-vnet"
$addressSpace     = "10.135.0.0/16"
$subnetName       = "servers"
$subnetIpRange    = "10.135.1.0/24"
$cliSubnetName    = "backend"
$cliSubnetIpRange = "10.135.133.0/24"

# Create resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create virtual network and subnet
$vNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vNetName -AddressPrefix $addressSpace -Location $location
Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vNetwork -AddressPrefix $subnetIpRange
Set-AzVirtualNetwork -VirtualNetwork $vNetwork
#endregion

#region azure-cli-example
az network vnet subnet create -g $resourceGroup --vnet-name $vNetName -n $cliSubnetName --address-prefixes $cliSubnetIpRange
#endregion

#region arm-deplyoment-example
New-AzResourceGroupDeployment -Name myDemoDeployment -ResourceGroupName $resourceGroup -TemplateFile .\ARM\vm-deploy.json -TemplateParameterFile .\ARM\vm-deploy.parameters.json -WhatIf
#endregion

