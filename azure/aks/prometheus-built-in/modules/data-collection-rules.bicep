param dataCollectionRules object

resource DataCollectionRules 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dataCollectionRules.name
  tags: dataCollectionRules.tags
  location: dataCollectionRules.region
  kind: dataCollectionRules.kind
  properties: {
    dataSources: dataCollectionRules.dataSources
    destinations: dataCollectionRules.destinations
    dataFlows: dataCollectionRules.dataFlows
  }
}
