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
      azureMonitorWorkspaceName: azureMonitorWorkspace.name
      clusterName: managedKubeCluster.name
    }
    dependsOn: [
      AzureMonitorWorkspaceDepoyment
    ]
  }
]

// module DataCollectionEndpointsDeployment './modules/data-collection-endpoints.bicep' = {
//   name: 'DataCollectionEndpointsDeployment'
//   params: {
//     dataCollectionEndpoints: dataCollectionEndpoints
//   }
// }

// module DataCollectionRuleAssociationsDeployment './modules/data-collection-rule-associations.bicep' = {}
