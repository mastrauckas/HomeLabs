param location string
param tags object

param externalVpn object

param virtualNetworkGatewayName string

param localVirtualNetworkGatewayName string
param remoteSubnetAddressPrefixes array

param connectionName string
param connectionMode string
param connectionProtocol string
param connectionType string
param connectionSharedKey string
param connectionUseLocalAzureIpAddress bool
param connectionEnableBgp bool
param connectionIpsecPolicies object[]
param connectionUsePolicyBasedTrafficSelectors bool
param connectionTrafficSelectorPolicies object[]
param connectionIngressNatRules object[]
param connectionEgressNatRules object[]
param connectionDpdTimeoutSeconds int

resource VpnPublicIpAddress 'Microsoft.Network/publicIPAddresses@2023-04-01' existing = {
  name: externalVpn.publicIpAddressName
  scope: resourceGroup(externalVpn.resourceGroup)
}

resource VirtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-04-01' existing = {
  name: virtualNetworkGatewayName
}

resource LocalVirtualNetworkGateway 'Microsoft.Network/localNetworkGateways@2023-04-01' = {
  name: localVirtualNetworkGatewayName
  location: location
  tags: tags
  properties: {
    gatewayIpAddress: VpnPublicIpAddress.properties.ipAddress
    localNetworkAddressSpace: {
      addressPrefixes: remoteSubnetAddressPrefixes
    }
  }
}

resource VirtualNetworkGatewayConnection 'Microsoft.Network/connections@2023-04-01' = {
  name: connectionName
  location: location
  tags: tags
  properties: {
    virtualNetworkGateway1: {
      id: VirtualNetworkGateway.id
      properties: {}
    }
    localNetworkGateway2: {
      id: LocalVirtualNetworkGateway.id
      properties: {}
    }
    connectionMode: connectionMode
    connectionProtocol: connectionProtocol
    connectionType: connectionType
    sharedKey: connectionSharedKey
    useLocalAzureIpAddress: connectionUseLocalAzureIpAddress
    enableBgp: connectionEnableBgp
    ipsecPolicies: connectionIpsecPolicies
    usePolicyBasedTrafficSelectors: connectionUsePolicyBasedTrafficSelectors
    trafficSelectorPolicies: connectionTrafficSelectorPolicies
    ingressNatRules: connectionIngressNatRules
    egressNatRules: connectionEgressNatRules
    dpdTimeoutSeconds: connectionDpdTimeoutSeconds
  }
}
