param location string

param sqlServerLogin string
@secure()
param sqlServerPassword string
param sqlServerName string
param sqlServerDatabaseName string
param minimalTlsVersion string

param sqlServerNetworkName string
param sqlServerNetworkSubnetName string
param sqlServerNetworkAddressSpace string

resource SqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerLogin
    administratorLoginPassword: sqlServerPassword
    minimalTlsVersion: minimalTlsVersion
  }
}

resource SqlServerDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: SqlServer
  name: sqlServerDatabaseName
  location: location
  sku: {
    name: 'Basic'
    size: 'Basic'
    tier: 'Basic'
  }
}

resource SqlServerNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: sqlServerNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        sqlServerNetworkAddressSpace
      ]
    }
    subnets: [
      {
        name: sqlServerNetworkSubnetName
        properties: {
          addressPrefix: sqlServerNetworkAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource PrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.database.windows.net'
  location: 'Global'
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: PrivateDnsZone
  name: '${PrivateDnsZone.name}-link'
  location: 'Global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: SqlServerNetwork.id
    }
  }
}

resource SqlPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  name: 'sql-servers-private-endpoint'
  location: location
  properties: {
    subnet: {
      id: SqlServerNetwork.properties.subnets[0].id
    }
    ipConfigurations: [
      {
        name: 'SqlServerIpAddress'
        properties: {
          groupId: 'sqlServer'
          memberName: 'sqlServer'
          privateIPAddress: '192.168.20.10'
        }
      }
    ]
    customNetworkInterfaceName: '${SqlServerNetwork.name}-nic'
    customDnsConfigs: [
      {
        ipAddresses: [
          '192.168.20.10'
        ]
      }
    ]
    privateLinkServiceConnections: [
      {
        name: '${SqlServerNetwork.name}-connection'
        properties: {
          privateLinkServiceId: SqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}

resource PrivateEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  parent: SqlPrivateEndpoint
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
}

output sqlServerNetworkName string = SqlServerNetwork.name
