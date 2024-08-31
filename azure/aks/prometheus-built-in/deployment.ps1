$region = 'eastus'
$resourceGroup = "k8s-prometheus-built-in-cluster-rg"

az group create `
    --resource-group $resourceGroup `
    --location $region;

az deployment group create `
    --name k8s-testing-deployment `
    --template-file ./main.bicep `
    --parameters ./parameters/main.bicepparam `
    --parameters region=$region `
    --resource-group $resourceGroup `
    --debug `
    --verbose;
