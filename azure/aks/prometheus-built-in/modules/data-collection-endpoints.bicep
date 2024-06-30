param dataCollectionEndpoints object

resource DataCollectionEndpoints 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' = {
  name: dataCollectionEndpoints.name
  location: dataCollectionEndpoints.region
  tags: dataCollectionEndpoints.tags
  kind: dataCollectionEndpoints.kind
  properties: {}
}
