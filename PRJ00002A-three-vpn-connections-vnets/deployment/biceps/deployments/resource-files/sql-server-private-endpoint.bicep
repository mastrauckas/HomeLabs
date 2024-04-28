param tags object

param sqlServerName string
param vNet object

param sqlServerPrivateEndpointName string
param sqlServerPrivateEndpointIpConfigurationName string
param sqlServerPrivateEndpointIpConfigurationPrivateIpAddress string
param sqlServerPrivateEndpointCustomDnsConfigIpAddress string

resource VNet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vNet.name
}

resource SqlServer 'Microsoft.Sql/servers@2021-11-01' existing = {
  name: sqlServerName
}

resource SqlPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: sqlServerPrivateEndpointName
  location: vNet.region
  tags: tags
  properties: {
    subnet: {
      id: filter(VNet.properties.subnets, sn => sn.name == vNet.subnetName)[0].id
    }
    ipConfigurations: [
      {
        name: sqlServerPrivateEndpointIpConfigurationName
        properties: {
          groupId: 'sqlServer'
          memberName: 'sqlServer'
          privateIPAddress: sqlServerPrivateEndpointIpConfigurationPrivateIpAddress
        }
      }
    ]
    customNetworkInterfaceName: '${sqlServerPrivateEndpointName}-nic'
    customDnsConfigs: [
      {
        ipAddresses: [
          sqlServerPrivateEndpointCustomDnsConfigIpAddress
        ]
      }
    ]
    privateLinkServiceConnections: [
      {
        name: '${sqlServerPrivateEndpointName}-link-connection'
        properties: {
          privateLinkServiceId: SqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}
