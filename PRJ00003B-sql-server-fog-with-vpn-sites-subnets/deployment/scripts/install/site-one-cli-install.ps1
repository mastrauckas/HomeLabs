az deployment group create `
    --name site-one-deployment `
    --template-file ./main.bicep `
    --parameters ./parameters-json/site-one-parameters.json `
    --resource-group site-one-rg `
    --debug `
    --verbose;
