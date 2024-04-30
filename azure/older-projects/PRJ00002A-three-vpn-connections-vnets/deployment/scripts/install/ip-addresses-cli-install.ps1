az group create `
    --resource-group site-one-rg `
    --location 'eastus';

az deployment group create `
    --name site-one-ip-address-deployment `
    --template-file ./ip-addresses-main.bicep `
    --parameters ./parameters-json/site-one-ip-address-for-vpn.json `
    --resource-group site-one-rg `
    --debug `
    --verbose;

az group create `
    --resource-group site-two-rg `
    --location 'eastus';

az deployment group create `
    --name site-two-ip-address-deployment `
    --template-file ./ip-addresses-main.bicep `
    --parameters ./parameters-json/site-two-ip-address-for-vpn.json `
    --resource-group site-two-rg `
    --debug `
    --verbose;

az group create `
    --resource-group site-three-rg `
    --location 'eastus';

az deployment group create `
    --name site-three-ip-address-deployment `
    --template-file ./ip-addresses-main.bicep `
    --parameters ./parameters-json/site-three-ip-address-for-vpn.json `
    --resource-group site-three-rg `
    --debug `
    --verbose;