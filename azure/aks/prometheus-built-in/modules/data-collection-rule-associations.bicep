param dataCollectionRuleAssociation object
param aksCusterName string
param dataCollectionRuleName string

resource aks 'Microsoft.ContainerService/managedClusters@2024-01-02-preview' existing = {
  name: aksCusterName
}

resource DataCollectionRules 'Microsoft.Insights/dataCollectionRules@2022-06-01' existing = {
  name: dataCollectionRuleName
}

resource DataCollectionRuleAssociations 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: dataCollectionRuleAssociation.name
  scope: aks
  properties: {
    dataCollectionRuleId: DataCollectionRules.id
    description: dataCollectionRuleAssociation.description
  }
}
