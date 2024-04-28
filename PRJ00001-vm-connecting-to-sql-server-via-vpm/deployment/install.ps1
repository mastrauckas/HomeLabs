# Connect-AzAccount
# -Mode Incremental

New-AzResourceGroup `
    -Name vpn-testing `
    -Location 'eastus';

New-AzResourceGroupDeployment `
    -Name MainDeployment `
    -ResourceGroupName  vpn-testing `
    -verbose `
    -TemplateFile .\biceps\main.bicep;