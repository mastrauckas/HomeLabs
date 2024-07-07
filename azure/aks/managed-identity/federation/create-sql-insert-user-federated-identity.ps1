# https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster
# https://github.com/Azure/bicep-types-az/issues/2024
$CLUSTER_NAME = "aks-test-cluster-eastus"
$RESOURCE_GROUP = "k8s-managed-identity-testing-eastus-rg"
$SERVICE_ACCOUNT_NAMESPACE = "default"
$SERVICE_ACCOUNT_NAME = "sql-server-insert-service-account" # This is the name in the k8s ServiceAccount
$USER_ASSIGNED_IDENTITY_NAME = "sql-insert-user" # Managed Identity name.
$FEDERATED_IDENTITY_CREDENTIAL_NAME = "sql-serverfederated-identity"
$AKS_OIDC_ISSUER = $(az aks show --name "${CLUSTER_NAME}" `
                --resource-group "${RESOURCE_GROUP}" `
                --query "oidcIssuerProfile.issuerUrl" `
                --output tsv);

az identity federated-credential create `
        --name $FEDERATED_IDENTITY_CREDENTIAL_NAME `
        --identity-name "$USER_ASSIGNED_IDENTITY_NAME" `
        --resource-group "$RESOURCE_GROUP" `
        --issuer "$AKS_OIDC_ISSUER" `
        --subject system:serviceaccount:"$SERVICE_ACCOUNT_NAMESPACE":"$SERVICE_ACCOUNT_NAME" `
        --audience api://AzureADTokenExchange