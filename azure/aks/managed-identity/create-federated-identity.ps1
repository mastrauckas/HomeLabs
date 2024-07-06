# https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster
$RESOURCE_GROUP = "k8s-managed-identity-testing-eastus-rg"
$SERVICE_ACCOUNT_NAMESPACE = "default"
$SERVICE_ACCOUNT_NAME = "sql-server-select-service-account" # This is the name in the k8s ServiceAccount
$USER_ASSIGNED_IDENTITY_NAME = "sql-select-user" # Managed Identity name.
$FEDERATED_IDENTITY_CREDENTIAL_NAME = "sql-serverfederated-identity"
$AKS_OIDC_ISSUER = "https://eastus.oic.prod-aks.azure.com/4b9b86fb-410c-4405-9b05-741cb1461e1d/a9f6d192-8eb5-4202-a6aa-1f10ee00b21a/"


az identity federated-credential create `
    --name $FEDERATED_IDENTITY_CREDENTIAL_NAME `
    --identity-name "$USER_ASSIGNED_IDENTITY_NAME" `
    --resource-group "$RESOURCE_GROUP" `
    --issuer "$AKS_OIDC_ISSUER" `
    --subject system:serviceaccount:"$SERVICE_ACCOUNT_NAMESPACE":"$SERVICE_ACCOUNT_NAME" `
    --audience api://AzureADTokenExchange