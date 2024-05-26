param tags object
param cosmosAccount object

param workspaceDiagnosticSettings object
param workspaceId string

resource CosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2024-02-15-preview' = {
  name: toLower(cosmosAccount.name)
  tags: tags
  location: cosmosAccount.region
  kind: cosmosAccount.kind
  identity: cosmosAccount.identity
  properties: {
    databaseAccountOfferType: cosmosAccount.databaseAccountOfferType
    locations: cosmosAccount.regions
    enableAutomaticFailover: cosmosAccount.enableAutomaticFailover
    isVirtualNetworkFilterEnabled: cosmosAccount.isVirtualNetworkFilterEnabled
    enableAnalyticalStorage: cosmosAccount.enableAnalyticalStorage

    minimalTlsVersion: cosmosAccount.minimalTlsVersion

    consistencyPolicy: cosmosAccount.consistencyPolicy

    capabilities: cosmosAccount.capabilities
    backupPolicy: cosmosAccount.backupPolicy
    enableMultipleWriteLocations: cosmosAccount.enableMultipleWriteLocations
    enableFreeTier: cosmosAccount.enableFreeTier
    capacity: cosmosAccount.capacity
    virtualNetworkRules: cosmosAccount.virtualNetworkRules
    ipRules: cosmosAccount.ipRules
    disableKeyBasedMetadataWriteAccess: cosmosAccount.disableKeyBasedMetadataWriteAccess
  }
}

resource DiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: workspaceDiagnosticSettings.name
  scope: CosmosDbAccount
  properties: {
    workspaceId: workspaceId
    logs: workspaceDiagnosticSettings.logs
    metrics: workspaceDiagnosticSettings.metrics
  }
}

var connectoinString = CosmosDbAccount.listConnectionStrings().connectionStrings[0].connectionString

output cosmosConnectionString string = connectoinString
