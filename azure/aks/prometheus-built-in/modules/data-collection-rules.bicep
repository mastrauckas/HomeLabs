param tags object
param dataCollectionRules object
param dataCollectionEndpointName string

resource DataCollectionEndpoints 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' existing = {
  name: dataCollectionEndpointName
}

resource DataCollectionRules 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dataCollectionRules.name
  tags: tags
  location: dataCollectionRules.region
  kind: dataCollectionRules.kind
  properties: {
    dataCollectionEndpointId: DataCollectionEndpoints.id
    dataSources: dataCollectionRules.dataSources
    destinations: dataCollectionRules.destinations
    dataFlows: dataCollectionRules.dataFlows
  }
}
