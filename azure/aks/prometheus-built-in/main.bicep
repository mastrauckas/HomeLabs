param tags object
param managedKubeCluster object
param azureMonitorWorkspace object
param dataCollectionEndpoints object
param dataCollectionRuleAssociations object
param dataCollectionRules object
param prometheusRuleGroups object[]
#disable-next-line no-unused-params
param region string

module KubeDeployment './modules/aks.bicep' = {
  name: 'KubeDeployment'
  params: {
    tags: tags
    managedKubeCluster: managedKubeCluster
  }
}

module AzureMonitorWorkspaceDepoyment './modules/azure-monitor-workspace.bicep' = {
  name: 'AzureMonitorWorkspaceDepoyment'
  params: {
    azureMonitorWorkspace: azureMonitorWorkspace
  }
}

module PrometheusRuleGroupDeployments './modules/prometheus-rule-group.bicep' = [
  for prometheusRuleGroup in prometheusRuleGroups: {
    name: 'PromRuleGroup-${prometheusRuleGroup.name}-Deployment'
    params: {
      tags: tags
      prometheusRuleGroups: prometheusRuleGroup
      azureMonitorWorkspaceId: AzureMonitorWorkspaceDepoyment.outputs.id
      clusterName: managedKubeCluster.name
    }
    dependsOn: [
      AzureMonitorWorkspaceDepoyment
      KubeDeployment
    ]
  }
]

module DataCollectionEndpointsDeployment './modules/data-collection-endpoints.bicep' = {
  name: 'DataCollectionEndpointsDeployment'
  params: {
    tags: tags
    dataCollectionEndpoints: dataCollectionEndpoints
  }
}

var completeDataCollectionRules = union(dataCollectionRules, {
  destinations: {
    monitoringAccounts: [
      {
        name: 'MonitoringAccount'
        accountResourceId: AzureMonitorWorkspaceDepoyment.outputs.id
      }
    ]
  }
})

module DataCollectionRulesDeployment './modules/data-collection-rules.bicep' = {
  name: 'DataCollectionRulesDeployment'
  params: {
    tags: tags
    dataCollectionRules: completeDataCollectionRules
    dataCollectionEndpointName: dataCollectionEndpoints.name
  }

  dependsOn: [
    AzureMonitorWorkspaceDepoyment
  ]
}

module DataCollectionRuleAssociationsDeployment './modules/data-collection-rule-associations.bicep' = {
  name: 'DataCollectionRuleAssociationsDeployment'
  params: {
    dataCollectionRuleAssociation: dataCollectionRuleAssociations
    aksCusterName: managedKubeCluster.name
    dataCollectionRuleName: dataCollectionRules.name
  }

  dependsOn: [
    DataCollectionEndpointsDeployment
    DataCollectionRulesDeployment
  ]
}
