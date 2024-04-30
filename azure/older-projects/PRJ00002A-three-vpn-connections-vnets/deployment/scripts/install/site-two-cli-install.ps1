az deployment group create `
    --name site-two-deployment `
    --template-file ./main.bicep `
    --parameters ./parameters-json/site-two-parameters.json `
    --resource-group site-two-rg `
    --debug `
    --verbose;
