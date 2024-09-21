param workspaceId string
param tags object
param applicationInsights object

resource ApplicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsights.name
  tags: tags
  location: applicationInsights.region
  kind: applicationInsights.kind
  properties: {
    Application_Type: applicationInsights.applicationType
    WorkspaceResourceId: workspaceId
  }
}
