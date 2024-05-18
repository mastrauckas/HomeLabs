param tags object
param cosmosAccount object
param workspace object
param workspaceDiagnosticSettings object

#disable-next-line no-unused-params
param myIpAddress string
#disable-next-line no-unused-params
param primaryRegion string

module WorkspaceDepoloyment './modules/workspace.bicep' = {
  name: 'workspace-deployment'
  params: {
    tags: tags
    workspace: workspace
  }
}

module CosmosAcccountDeployment './modules/cosmos-account.bicep' = {
  name: 'cosmos-account-deployment'
  params: {
    tags: tags
    cosmosAccount: cosmosAccount

    workspaceDiagnosticSettings: workspaceDiagnosticSettings
    workspaceId: WorkspaceDepoloyment.outputs.workspaceId
  }
}
