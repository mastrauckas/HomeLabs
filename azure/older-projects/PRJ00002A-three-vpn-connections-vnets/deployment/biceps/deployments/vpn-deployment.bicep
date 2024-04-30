param tags object
param vpnSettings object

var remoteSites = vpnSettings.remoteSites
var vpn = vpnSettings.vpn
var vNet = vpnSettings.vNet
var publicIpAddress = vpnSettings.publicIpAddress
var region = vpnSettings.region

module VpnIpAddressDeployments './resource-files/ip-address.bicep' = {
  name: '${publicIpAddress.name}-deployment'
  params: {
    location: region
    tags: tags

    publicIpAddressName: publicIpAddress.name
    publicIpAddressVersion: publicIpAddress.version
    publicIpAllocationMethod: publicIpAddress.allocationMethod
    publicIpAddressSku: publicIpAddress.sku
    publicIpAddressTier: publicIpAddress.tier
  }
}

module Vpn './resource-files/vpn.bicep' = {
  name: 'vpn-deployment'
  params: {
    location: region
    tags: tags

    virtualNetworkGatewayName: vpn.name

    ipConfigurationName: vpn.ipConfigurationName

    enablePrivateIpAddress: vpn.enablePrivateIpAddress
    skuName: vpn.sku
    skuTier: vpn.skuTier
    vpnType: vpn.type
    enableBgp: vpn.enableBgp
    activeActive: vpn.activeActive
    gatewayGeneration: vpn.gatewayGeneration
    gatewayType: vpn.gatewayType

    vNet: vNet

    publicIpAddressName: publicIpAddress.name
  }
  dependsOn: [
    VpnIpAddressDeployments
  ]
}

module VpnConnection './resource-files/vpn-connection.bicep' = [for remoteSite in remoteSites: {
  name: 'vpn-connection-${remoteSite.localNetworkGateway.name}-deployment'
  params: {
    location: region
    tags: tags

    externalVpn: remoteSite.connection.externalVpn

    virtualNetworkGatewayName: vpn.name

    localVirtualNetworkGatewayName: remoteSite.localNetworkGateway.name
    remoteSubnetAddressPrefixes: remoteSite.localNetworkGateway.subnetAddressPrefixes

    connectionName: remoteSite.connection.name
    connectionMode: remoteSite.connection.connectionMode
    connectionProtocol: remoteSite.connection.connectionProtocol
    connectionType: remoteSite.connection.connectionType
    connectionSharedKey: remoteSite.connection.sharedKey
    connectionUseLocalAzureIpAddress: remoteSite.connection.useLocalAzureIpAddress
    connectionEnableBgp: remoteSite.connection.enableBgp
    connectionIpsecPolicies: remoteSite.connection.ipsecPolicies
    connectionUsePolicyBasedTrafficSelectors: remoteSite.connection.usePolicyBasedTrafficSelectors
    connectionTrafficSelectorPolicies: remoteSite.connection.trafficSelectorPolicies
    connectionIngressNatRules: remoteSite.connection.ingressNatRules
    connectionEgressNatRules: remoteSite.connection.egressNatRules
    connectionDpdTimeoutSeconds: remoteSite.connection.dpdTimeoutSeconds

  }
  dependsOn: [
    Vpn
  ]
}]
