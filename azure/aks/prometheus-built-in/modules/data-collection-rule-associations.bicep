param dataCollectionRuleAssociation object
param dataCollectionEndpointId string
param dataCollectionRuleId string

resource DataCollectionRuleAssociations 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: dataCollectionRuleAssociation.name
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    dataCollectionRuleId: dataCollectionRuleId
    description: dataCollectionRuleAssociation.description
  }
}
