$developmentSubscriptionId = "blah";
$defaultSubscription = az account list --query "[?isDefault].id" --output tsv
$primaryRegion = 'eastus'

$publicIpAddress = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()

If ($defaultSubscription -eq $developmentSubscriptionId) {

    $environmentPrefix = Read-Host "Please enter your envoriment name to use as a prefix";
    $environmentPrefix = $environmentPrefix.Trim();
    if ($environmentPrefix -eq '') {
        Write-Host "Environment prefix must have a value."
        return;
    }

    $resourceGroup = Read-Host "Please enter your Resource Group name";
    $resourceGroup = $resourceGroup.Trim();
    if ($resourceGroup -eq '') {
        Write-Host "Resource Group must have a value."
        return;
    }

    Write-Host "Using Resource Group '$resourceGroup' with envoriment prefex '$environmentPrefix'.";

    az deployment group create `
        --name main-deployment `
        --resource-group $resourceGroup `
        --template-file ./main.bicep `
        --parameters ./parameters/local-development.bicepparam `
        --parameters primaryRegion=$primaryRegion `
        --parameters environmentPrefix=$environmentPrefix `
        --parameters myIpAddress=$publicIpAddress `;
}
else {
    Write-Host 'You are not on the development subscription.'
}
