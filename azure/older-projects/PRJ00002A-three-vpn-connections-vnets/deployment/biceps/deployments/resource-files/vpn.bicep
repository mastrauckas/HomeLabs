param location string
param tags object

param virtualNetworkGatewayName string

param ipConfigurationName string

param enablePrivateIpAddress bool
param skuName string
param skuTier string
param enableBgp bool
param activeActive bool
param gatewayGeneration string
param gatewayType string
param vpnType string

param publicIpAddressName string

param vNet object

resource PublicIpAddress 'Microsoft.Network/publicIPAddresses@2023-04-01' existing = {
  name: publicIpAddressName
}

resource VNet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vNet.name
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-04-01' = {
  name: virtualNetworkGatewayName
  location: location
  tags: tags
  properties: {
    enablePrivateIpAddress: enablePrivateIpAddress
    ipConfigurations: [
      {
        name: ipConfigurationName
        properties: {
          publicIPAddress: {
            id: PublicIpAddress.id
          }
          subnet: {
            id: filter(VNet.properties.subnets, sn => sn.name == vNet.subnetName)[0].id
          }
        }
      }
    ]
    sku: {
      name: skuName
      tier: skuTier
    }
    gatewayType: gatewayType
    vpnType: vpnType
    enableBgp: enableBgp
    activeActive: activeActive
    vpnGatewayGeneration: gatewayGeneration
  }
}
