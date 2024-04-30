New-AzResourceGroup `
    -Name site-one-rg `
    -Location 'eastus';

New-AzResourceGroupDeployment `
    -Name site-one-ip-address-deployment `
    -ResourceGroupName site-one-rg `
    -Verbose `
    -TemplateFile  ./ip-addresses-main.bicep `
    -TemplateParameterFile ./parameters-json/site-one-ip-address-for-vpn.json;

New-AzResourceGroup `
    -Name site-two-rg `
    -Location 'eastus';

New-AzResourceGroupDeployment `
    -Name site-two-ip-address-deployment `
    -ResourceGroupName site-two-rg `
    -Verbose `
    -TemplateFile  ./ip-addresses-main.bicep `
    -TemplateParameterFile ./parameters-json/site-two-ip-address-for-vpn.json;

New-AzResourceGroup `
    -Name site-three-rg `
    -Location 'eastus';

New-AzResourceGroupDeployment `
    -Name site-three-ip-address-deployment `
    -ResourceGroupName site-three-rg `
    -Verbose `
    -TemplateFile  ./ip-addresses-main.bicep `
    -TemplateParameterFile ./parameters-json/site-three-ip-address-for-vpn.json;