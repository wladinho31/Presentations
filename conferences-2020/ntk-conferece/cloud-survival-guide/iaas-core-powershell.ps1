# Define Parameters
$location          = 'northeurope'
$resourceGroupName = "ntk2020-rg"
$vNetName          = "ntk2020-vNet"
$addressSpace      = "10.123.0.0/16"
$subnetIPRange     = "10.123.1.0/24"
$subnetName        = "servers"
$nsgName           = "ntk2020-nsg"

# Create resource group
if (Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -match $resourceGroupName}) {
    Write-Host $resourceGroupName already exist -ForegroundColor Cyan
    }
    else {    
        Write-Host $resourceGroupName creating ... Please wait -ForegroundColor Yellow
        New-AzResourceGroup -Name $resourceGroupName -Location $location
        if (Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -match $resourceGroupName}) {
            Write-Host Resource Group $resourceGroupName successfully created. -ForegroundColor Green
            }
}

# Create virtual network and subnet
$vNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vNetName -AddressPrefix $AddressSpace -Location $location
Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $vNetwork -AddressPrefix $SubnetIPRange
Set-AzVirtualNetwork -VirtualNetwork $vNetwork

    if (Get-AzVirtualNetwork | Where-Object {$_.Name -like "$vNetName"}) {
        Write-Host Virtual Network $vNetName is successfully created. Address space is $AddressSpace. -ForegroundColor Green
        }

# Create Network Security Group
$nsgRuleVMAccess = New-AzNetworkSecurityRuleConfig -Name 'allow-vm-access' -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22,3389 -Access Allow
New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name $nsgName -SecurityRules $nsgRuleVMAccess

    if (Get-AzNetworkSecurityGroup | Where-Object {$_.Name -like "$nsgName"}) {
        Write-Host Network Security Groups $nsgName is successfully created with included $nsgRuleVMAccess.Name rule. -ForegroundColor Green 
        }
