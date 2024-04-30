param vNetPeeringName string

param fromName string
param toName string

param allowVirtualNetworkAccess bool
param allowForwardedTraffic bool
param allowGatewayTransit bool
param useRemoteGateways bool

resource ParentVirtueNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: fromName
}

resource RemoteVirtueNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: toName
}

resource VirtualNetworkPeering 'microsoft.network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  parent: ParentVirtueNetwork
  name: vNetPeeringName
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: RemoteVirtueNetwork.id
    }
  }
}
