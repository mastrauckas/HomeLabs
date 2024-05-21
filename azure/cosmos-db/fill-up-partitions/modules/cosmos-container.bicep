param tags object
param cosmosAccountName string
param cosmosDatabaseName string
param cosmosContainer object

resource CosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2024-02-15-preview' existing = {
  name: cosmosAccountName

  resource CosmosDbDatabase 'sqlDatabases@2024-02-15-preview' existing = {
    name: cosmosDatabaseName

    resource CosmosDbContainer 'containers@2024-02-15-preview' = {
      name: cosmosContainer.name
      tags: tags
      properties: {
        resource: {
          id: cosmosContainer.name
          partitionKey: cosmosContainer.partitionKey
          indexingPolicy: cosmosContainer.indexingPolicy
          defaultTtl: cosmosContainer.defaultTtl
          uniqueKeyPolicy: cosmosContainer.uniqueKeyPolicy
        }
        options: {
          autoscaleSettings: cosmosContainer.autoscaleSettings
          throughput: cosmosContainer.throughput
        }
      }
    }
  }
}
