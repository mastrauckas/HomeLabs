$developmentSubscriptionId = '98f367ec-c391-476a-b984-cb1468cf199f';
$defaultSubscription = az account list --query "[?isDefault].id" --output tsv
$primaryRegion = 'eastus2'
$resourceGroup = 'cosmos-db-testing-rg'

$publicIpAddress = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()

If ($defaultSubscription -eq $developmentSubscriptionId) {

    $example = Read-Host -Prompt 'What example do you want to create'

    if ($example -eq 1) {
        $scriptFile = './parameters/example-one-parameters.bicepparam'
    }
    else {
        Write-Host 'Incorrect example.'
        return
    }

    az group create -l $primaryRegion -n $resourceGroup

    az deployment group create `
        --name main-deployment `
        --resource-group $resourceGroup `
        --template-file ./main.bicep `
        --parameters ./parameters/parameters.bicepparam `
        --parameters primaryRegion=$primaryRegion `
        --parameters myIpAddress=$publicIpAddress;
}
else {
    Write-Host 'You are not on the ''Learning subscription''.'
}
