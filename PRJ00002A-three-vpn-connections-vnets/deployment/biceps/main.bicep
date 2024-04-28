param installationSettings object

var tags = installationSettings.tags
var vNetSettings = installationSettings.vNetSettings
var vpnSettings = installationSettings.vpnSettings
var sqlServerSettings = installationSettings.sqlServerSettings
var virtualMachineSettings = installationSettings.virtualMachineSettings
var peeringVirtualNetworkSettings = installationSettings.peeringVirtualNetworkSettings
var privateDnsZoneLinkSettings = installationSettings.privateDnsZoneLinkSettings
var privateDnsResolverSettings = installationSettings.privateDnsResolverSettings

module vNetDeployment './deployments/vnet-deployment.bicep' = if (vNetSettings != null) {
  name: 'vnet-driver-deployment'
  params: {
    tags: tags
    vNetSettings: vNetSettings
  }
}

module VpnDeployment './deployments/vpn-deployment.bicep' = if (vpnSettings != null) {
  name: 'vpn-driver-deployment'
  params: {
    tags: tags
    vpnSettings: vpnSettings
  }

  dependsOn: [
    vNetDeployment
  ]
}

module SqlServerDriverDeployment './deployments/sql-server-deployment.bicep' = if (sqlServerSettings != null) {
  name: 'sql-server-driver-deployment'
  params: {
    tags: tags
    sqlServerSettings: sqlServerSettings
  }

  dependsOn: [
    vNetDeployment
  ]
}

module VmDriverDeployment './deployments/vm-deployment.bicep' = if (virtualMachineSettings != null) {
  name: 'vm-driver-deployment'
  params: {
    tags: tags
    virtualMachineSettings: virtualMachineSettings
  }

  dependsOn: [
    vNetDeployment
  ]
}

module PeeringDriverDeployment './deployments/peering-deployment.bicep' = if (peeringVirtualNetworkSettings != null) {
  name: 'peering-driver-deployment'
  params: {
    peeringVirtualNetworkSettings: peeringVirtualNetworkSettings
  }

  dependsOn: [
    SqlServerDriverDeployment
    VmDriverDeployment
    VpnDeployment
  ]
}

module PrivateDnsVirtualNetworkLinkDriverDeployment './deployments/private-dns-virtual-network-link-deployment.bicep' = if (privateDnsZoneLinkSettings != null) {
  name: 'private-dns-virtual-network-link-driver-deployment'
  params: {
    tags: tags
    privateDnsZoneLinkSettings: privateDnsZoneLinkSettings
  }

  dependsOn: [
    SqlServerDriverDeployment
    VmDriverDeployment
    VpnDeployment
  ]
}

module PrivateDnsResolverDriverDeployment './deployments/dns-private-resolver-deployment.bicep' = if (privateDnsResolverSettings != null) {
  name: 'private-dns-resolver-driver-deployment'
  params: {
    tags: tags
    privateDnsResolverSettings: privateDnsResolverSettings
  }

  dependsOn: [
    VpnDeployment
  ]
}
