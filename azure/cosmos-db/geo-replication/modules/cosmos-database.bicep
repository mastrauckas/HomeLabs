param tags object
param cosmosAccountName string
param cosmosDatabase object

resource CosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2024-02-15-preview' existing = {
  name: cosmosAccountName
}

resource CosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-02-15-preview' = {
  parent: CosmosDbAccount
  name: cosmosDatabase.name
  tags: tags
  properties: {
    resource: {
      id: cosmosDatabase.name
      createMode: cosmosDatabase.createMode
      restoreParameters: cosmosDatabase.restoreParameters
    }
    options: {
      autoscaleSettings: cosmosDatabase.autoscaleSettings
      throughput: cosmosDatabase.throughput
    }
  }
}
