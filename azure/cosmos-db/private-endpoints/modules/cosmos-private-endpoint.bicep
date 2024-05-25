param privateEndpoint object
param cosmosAccountName string

resource VNet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: privateEndpoint.vNetName
}

resource CosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2024-02-15-preview' existing = {
  name: cosmosAccountName
}

resource PrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: privateEndpoint.name
  location: privateEndpoint.region
  properties: {
    subnet: {
      id: filter(VNet.properties.subnets, sn => sn.name == privateEndpoint.subnetName)[0].id
    }
    ipConfigurations: [
      for ipConfiguration in privateEndpoint.ipConfigurations: {
        name: ipConfiguration.name
        properties: {
          groupId: ipConfiguration.groupId
          memberName: ipConfiguration.memberName
          privateIPAddress: ipConfiguration.privateIPAddress
        }
      }
    ]
    customNetworkInterfaceName: privateEndpoint.customNetworkInterfaceName
    privateLinkServiceConnections: [
      for privateLinkServiceConnection in privateEndpoint.privateLinkServiceConnections: {
        name: '${privateLinkServiceConnection.name}-link-connection'
        properties: {
          privateLinkServiceId: CosmosDbAccount.id
          groupIds: privateLinkServiceConnection.groupIds
        }
      }
    ]
  }
}

resource PrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateEndpoint.privateDnsZone.name
}

resource PrivateEndpointDnsGroups 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = [
  for (privateDnsZoneGroup, index) in privateEndpoint.privateDnsZone.privateDnsZonGroups: {
    parent: PrivateEndpoint
    name: privateDnsZoneGroup.name
    properties: {
      privateDnsZoneConfigs: [
        {
          name: '${PrivateDnsZone.name}-zone-group-configuration'
          properties: {
            privateDnsZoneId: PrivateDnsZone.id
          }
        }
      ]
    }
  }
]

resource PrivateDnsZonesVirtualNetworkLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [
  for privateDnsZonesVirtualNetwork in privateEndpoint.privateDnsVNetLinks: {
    parent: PrivateDnsZone
    name: privateDnsZonesVirtualNetwork.name
    location: 'Global'
    properties: {
      registrationEnabled: privateDnsZonesVirtualNetwork.registrationEnabled
      virtualNetwork: {
        id: VNet.id
      }
    }
  }
]
