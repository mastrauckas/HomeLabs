param peeringVirtualNetworkSettings object

module FromVmToSqlServerPerring './resource-files/peering.bicep' = [for peeringVirtualNetwork in peeringVirtualNetworkSettings.peeringVirtualNetworks: {
  name: '${peeringVirtualNetwork.name}-deployment'
  params: {
    vNetPeeringName: peeringVirtualNetwork.name

    fromName: peeringVirtualNetwork.fromName
    toName: peeringVirtualNetwork.toName

    allowVirtualNetworkAccess: peeringVirtualNetwork.allowVirtualNetworkAccess
    allowForwardedTraffic: peeringVirtualNetwork.allowForwardedTraffic
    allowGatewayTransit: peeringVirtualNetwork.allowGatewayTransit
    useRemoteGateways: peeringVirtualNetwork.useRemoteGateways
  }
}]
