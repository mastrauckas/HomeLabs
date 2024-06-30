param dataCollectionRuleAssociation object
param dataCollectionEndpointName string
param dataCollectionRuleName string

resource DataCollectionEndpoints 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' existing = {
  name: dataCollectionEndpointName
}

resource DataCollectionRules 'Microsoft.Insights/dataCollectionRules@2022-06-01' existing = {
  name: dataCollectionRuleName
}

resource DataCollectionRuleAssociations 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: dataCollectionRuleAssociation.name
  properties: {
    dataCollectionEndpointId: DataCollectionEndpoints.id
    dataCollectionRuleId: DataCollectionRules.id
    description: dataCollectionRuleAssociation.description
  }
}
