param tags object
param prometheusRuleGroups object
param azureMonitorWorkspaceName string
param clusterName string

resource AzureMonitorWorkspace 'microsoft.monitor/accounts@2021-06-03-preview' existing = {
  name: azureMonitorWorkspaceName
}

resource PrometheusRuleGroup 'Microsoft.AlertsManagement/prometheusRuleGroups@2021-07-22-preview' = {
  name: prometheusRuleGroups.name
  location: prometheusRuleGroups.region
  tags: tags
  properties: {
    clusterName: clusterName
    description: prometheusRuleGroups.description
    enabled: prometheusRuleGroups.enabled
    interval: prometheusRuleGroups.interval
    rules: prometheusRuleGroups.rules
    scopes: [
      AzureMonitorWorkspace.id
    ]
  }
}
