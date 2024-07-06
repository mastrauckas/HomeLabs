$region = 'eastus'
$resourceGroup = "k8s-managed-identity-testing-$region-rg"

az group create `
    --resource-group $resourceGroup `
    --location $region;

az deployment group validate `
    --name k8s-testing-deployment `
    --template-file ./main.bicep `
    --parameters ./parameters/main.bicepparam `
    --parameters region=$region `
    --resource-group $resourceGroup `
    --debug `
    --verbose;
