param location string = resourceGroup().location

//  SQL Server
param sqlServerLogin string = 'michael'
@secure()
param sqlServerPassword string = 'testing12345$'
param sqlServerName string = 'maa-sql-server'
param sqlServerDatabaseName string = 'TestingDatabase'
param minimalTlsVersion string = '1.2'

param sqlServerNetworkName string = 'sql-server-network'
param sqlServerNetworkSubnetName string = 'sql-server-subnet'
param sqlServerNetworkAddressSpace string = '192.168.20.0/24'

// VPN
param vpnNetworGatewaykName string = 'vpn-network'

param vpnNetworkAddressSpace string = '192.168.10.0/24'
param vpnNetworkGatewaySubnetAddressSpace string = '192.168.10.0/24'
param vpnPublicIpAddressName string = 'vpn-ip-address'
param vpnPublicIpAddressVersion string = 'IPv4'
param vpnPublicIpAllocationMethod string = 'Dynamic'
param vpnPublicIpAddressSku string = 'Basic'
param vpnPublicIpAddressTeir string = 'Regional'

param vpnLocalNetworkGatewayName string = 'vpn-local-network'
param vpnLocalGatewayIpAddress string = '75.176.73.70'
param vpnLocalGatewayAddressPrefixes string = '10.0.100.0/24'

module SqlServerDeployment 'sql-server.bicep' = {
  name: 'SqlServerDeployment'
  params: {
    location: location
    sqlServerLogin: sqlServerLogin
    sqlServerPassword: sqlServerPassword
    sqlServerName: sqlServerName
    sqlServerDatabaseName: sqlServerDatabaseName
    minimalTlsVersion: minimalTlsVersion
    sqlServerNetworkName: sqlServerNetworkName
    sqlServerNetworkSubnetName: sqlServerNetworkSubnetName
    sqlServerNetworkAddressSpace: sqlServerNetworkAddressSpace
  }
}

module VpnDeployment 'vpn.bicep' = {
  name: 'VpnDeployment'
  params: {
    location: location
    vpnNetworGatewaykName: vpnNetworGatewaykName
    vpnNetworkAddressSpace: vpnNetworkAddressSpace
    vpnNetworkGatewaySubnetAddressSpace: vpnNetworkGatewaySubnetAddressSpace
    vpnPublicIpAddressName: vpnPublicIpAddressName
    vpnPublicIpAddressVersion: vpnPublicIpAddressVersion
    vpnPublicIpAllocationMethod: vpnPublicIpAllocationMethod
    vpnPublicIpAddressSku: vpnPublicIpAddressSku
    vpnPublicIpAddressTeir: vpnPublicIpAddressTeir

    vpnLocalNetworkGatewayName: vpnLocalNetworkGatewayName
    vpnLocalGatewayIpAddress: vpnLocalGatewayIpAddress
    vpnLocalGatewayAddressPrefixes: vpnLocalGatewayAddressPrefixes

    sqlServerNetworkName: SqlServerDeployment.outputs.sqlServerNetworkName
  }
}

module VmsDeployment 'vms.bicep' = {
  name: 'VmsDeployment'
  params: {
    location: location

    sqlServerNetworkName: SqlServerDeployment.outputs.sqlServerNetworkName
  }
}
