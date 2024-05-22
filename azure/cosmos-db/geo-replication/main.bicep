param tags object
param cosmosAccount object
param workspace object
param workspaceDiagnosticSettings object
param ipAddresses object[]
param vNets array
param vms array
param privateEndpoints array

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
    }
    dependsOn: [
      CosmosAcccountDeployment
      CosmosDatabaseDeployment
    ]
  }
]

module VpnIpAddress './modules/ip-address.bicep' = [
  for ipAddress in ipAddresses: {
    name: '${ipAddress.name}-deployment'
    params: {
      location: ipAddress.region
      tags: tags

      name: ipAddress.name
      version: ipAddress.version
      allocationMethod: ipAddress.allocationMethod
      sku: ipAddress.sku
      tier: ipAddress.tier
    }
  }
]

module VNetDeployments 'modules/vnet.bicep' = [
  for vnet in vNets: {
    name: '${vnet.name}-deployment'
    params: {
      location: vnet.region
      tags: tags

      vNetName: vnet.name
      addressPrefixes: vnet.addressPrefixes
      subnets: vnet.subnets
    }
    dependsOn: [
      VpnIpAddress
    ]
  }
]

module VmDeployments 'modules/vm.bicep' = [
  for virtualMachine in vms: {
    name: '${virtualMachine.name}-deployment'
    params: {
      location: virtualMachine.region
      tags: tags

      vmName: virtualMachine.name
      vmSize: virtualMachine.vmSize

      adminUserName: virtualMachine.adminUserName
      adminPassword: virtualMachine.adminPassword

      computerName: virtualMachine.computerName
      zones: virtualMachine.zones
      timeZone: virtualMachine.timeZone
      licenseType: virtualMachine.licenseType
      publisher: virtualMachine.publisher
      offer: virtualMachine.offer
      sku: virtualMachine.sku
      version: virtualMachine.version

      okDiskName: virtualMachine.okDiskName
      caching: virtualMachine.caching
      createOption: virtualMachine.createOption
      storageAccountType: virtualMachine.storageAccountType
      diskSizeGB: virtualMachine.diskSizeGB

      networkInterface: virtualMachine.networkInterface
    }
    dependsOn: [
      VpnIpAddress
      VNetDeployments
    ]
  }
]

module PrivateDnsZones './modules/privateDnsZones.bicep' = {
  name: 'cosmos-dns-zone'
  params: {
    name: privateEndpoints[0].privateDnsZone.name
  }
}

// @batchSize(1)
module PriveLinkDeployments 'modules/cosmos-private-endpoint.bicep' = [
  for privateEndpoint in privateEndpoints: {
    name: '${privateEndpoint.name}-pl-deployment'
    params: {
      privateEndpoint: privateEndpoint
      cosmosAccountName: cosmosAccount.name
    }
    dependsOn: [
      PrivateDnsZones
      VNetDeployments
      CosmosAcccountDeployment
    ]
  }
]
