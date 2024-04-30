param location string

param vpnNetworGatewaykName string
param vpnNetworkAddressSpace string
param vpnNetworkGatewaySubnetAddressSpace string

param vpnPublicIpAddressName string
param vpnPublicIpAddressVersion string
param vpnPublicIpAllocationMethod string
param vpnPublicIpAddressSku string
param vpnPublicIpAddressTeir string

param vpnLocalNetworkGatewayName string
param vpnLocalGatewayIpAddress string
param vpnLocalGatewayAddressPrefixes string

param sqlServerNetworkName string

resource VpnNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: vpnNetworGatewaykName
  location: location
  tags: {
    Owner: 'Michael'
    Purpose: 'Testing'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vpnNetworkAddressSpace
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vpnNetworkGatewaySubnetAddressSpace
        }
      }
    ]
  }
}

resource VpnPublicIpAddress 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: vpnPublicIpAddressName
  location: location
  properties: {
    publicIPAllocationMethod: vpnPublicIpAllocationMethod
    publicIPAddressVersion: vpnPublicIpAddressVersion
    idleTimeoutInMinutes: 4
  }
  sku: {
    name: vpnPublicIpAddressSku
    tier: vpnPublicIpAddressTeir
  }
}

resource VpnTunnel 'Microsoft.Network/virtualNetworkGateways@2022-11-01' = {
  name: 'vpn-tunnel'
  location: location
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'VpnIpAddress'
        properties: {
          publicIPAddress: {
            id: VpnPublicIpAddress.id
          }
          subnet: {
            id: VpnNetwork.properties.subnets[0].id
          }
        }
      }
    ]
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    vpnGatewayGeneration: 'Generation1'
  }
}

resource VpnLocalGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' = {
  name: vpnLocalNetworkGatewayName
  location: location
  properties: {
    gatewayIpAddress: vpnLocalGatewayIpAddress
    localNetworkAddressSpace: {
      addressPrefixes: [ vpnLocalGatewayAddressPrefixes ]
    }
  }
}

resource VpnConnection 'Microsoft.Network/connections@2022-11-01' = {
  name: 'vpn-connection'
  location: location
  properties: {
    virtualNetworkGateway1: {
      id: VpnTunnel.id
      properties: {}
    }
    localNetworkGateway2: {
      id: VpnLocalGateway.id
      properties: {}
    }
    connectionType: 'IPsec'
    sharedKey: 'testing12345$'
  }
}

resource SqlServerNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: sqlServerNetworkName
}

resource SqlServerNetworkPeering 'microsoft.network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: VpnNetwork
  name: 'VpnNetworkToSqlServerNetworkLink'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: SqlServerNetwork.id
    }
  }
}
