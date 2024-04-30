param tags object

param privateDnsZoneVirtualLinkName string

param privateDnsZoneName string
param vNetName string

param registrationEnabled bool

resource PrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource VNet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vNetName
}

resource PrivateDnsZonesVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: PrivateDnsZone
  name: privateDnsZoneVirtualLinkName
  location: 'Global'
  tags: tags
  properties: {
    registrationEnabled: registrationEnabled
    virtualNetwork: {
      id: VNet.id
    }
  }
}
