param tags object
param workspace object

resource Workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspace.name
  tags: tags
  location: workspace.region
  properties: {
    sku: workspace.sku
    retentionInDays: workspace.retentionInDays
    publicNetworkAccessForIngestion: workspace.publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: workspace.publicNetworkAccessForQuery
    workspaceCapping: workspace.workspaceCapping
  }
}

output workspaceId string = Workspace.id
