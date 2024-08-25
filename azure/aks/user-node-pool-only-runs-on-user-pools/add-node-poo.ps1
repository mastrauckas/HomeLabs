# https://learn.microsoft.com/en-us/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-add
az aks nodepool add `
    --resource-group k8s-testing-cluster-eastus-rg `
    --cluster-name k8s-testing-cluster-rg `
    --name userpool1 `
    --node-count 1 `
    --mode User `
    --max-pods 100 `
    --os-type Linux `
    --node-vm-size Standard_B2s `
    --node-osdisk-siz 30 `
    --priority Regular;