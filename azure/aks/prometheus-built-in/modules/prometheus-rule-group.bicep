param tags object
param prometheusRuleGroups object
param azureMonitorWorkspaceId string
param clusterName string

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
      azureMonitorWorkspaceId
    ]
  }
}
