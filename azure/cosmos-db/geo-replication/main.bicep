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

module CosmosDatabaseDeployment './modules/cosmos-database.bicep' = {
  name: 'cosmos-database-deployment'
  params: {
    tags: tags
    cosmosAccountName: cosmosAccount.name
    cosmosDatabase: cosmosAccount.database
  }

  dependsOn: [
    CosmosAcccountDeployment
  ]
}

module CosmosContainerDeployment './modules/cosmos-container.bicep' = [
  for container in cosmosAccount.containers: {
    name: 'cosmos-container-${container.name}-deployment'
    params: {
      tags: tags
      cosmosAccountName: cosmosAccount.name
      cosmosDatabaseName: cosmosAccount.database.name
      cosmosContainer: container
      // region: primaryRegion
    }
    dependsOn: [
      CosmosAcccountDeployment
      CosmosDatabaseDeployment
    ]
  }
]
