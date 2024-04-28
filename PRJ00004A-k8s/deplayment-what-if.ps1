$resourceGroup = 'k8s-testing-rg'

az group create `
    --resource-group $resourceGroup `
    --location 'eastus';

az deployment group what-if `
    --name k8s-testing-deployment `
    --template-file ./main.bicep `
    --parameters ./parameters/main.bicepparam `
    --resource-group $resourceGroup `
    --debug `
    --verbose;
