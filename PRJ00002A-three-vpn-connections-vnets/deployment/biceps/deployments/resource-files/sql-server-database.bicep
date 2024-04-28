param location string
param tags object

param serverName string

param databaseName string
param skuName string
param skuSize string
param skuTier string

resource SqlServer 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource SqlServerDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: SqlServer
  name: databaseName
  location: location
  tags: tags
  sku: {
    name: skuName
    size: skuSize
    tier: skuTier
  }
}
