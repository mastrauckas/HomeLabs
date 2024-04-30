param tags object
param privateDnsZone object

resource PrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZone.name
  location: 'Global'
  tags: tags
}

resource PrivateEndpoints 'Microsoft.Network/privateEndpoints@2023-04-01' existing = [for privateEndpointName in privateDnsZone.endpoints: {
  name: privateEndpointName.privateEndpointName
}]

resource PrivateEndpointDnsGroups 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = [for (privateDnsZoneGroup, index) in privateDnsZone.endpoints: {
  parent: PrivateEndpoints[index]
  name: '${PrivateDnsZone.name}-zone-group'
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
}]
