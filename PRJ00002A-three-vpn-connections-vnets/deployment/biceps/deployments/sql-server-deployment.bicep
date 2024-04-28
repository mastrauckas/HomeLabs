param tags object
param sqlServerSettings object

var sqlServers = concat(array(sqlServerSettings.primarySqlServer), sqlServerSettings.secondarySqlServers)
var databaseNames = map(sqlServerSettings.primarySqlServer.databases, (databaseName) => databaseName.name)
var databases = sqlServerSettings.primarySqlServer.databases
var privateDnsZone = sqlServerSettings.privateDnsZone == null ? {} : {
  name: sqlServerSettings.privateDnsZone.name
  endpoints: map(sqlServers, (sqlServer) => {
      privateEndpointName: sqlServer.privateEndpoint.name
      privateDnsZoneGroups: sqlServer.privateEndpoint.privateDnsZoneGroups
    })
}

module SqlServerDeployment './resource-files/sql-server.bicep' = [for sqlServer in sqlServers: {
  name: '${sqlServer.sqlServer.name}-deployment'
  params: {
    location: sqlServer.region
    tags: tags

    serverName: sqlServer.sqlServer.name

    adminLoginName: sqlServer.sqlServer.adminLoginName
    adminPassword: sqlServer.sqlServer.adminPassword

    minimalTlsVersion: sqlServer.sqlServer.minimalTlsVersion
  }
}]

module SqlServerDatabaseDeployments './resource-files/sql-server-database.bicep' = [for database in databases: {
  name: 'sql-server-database-${database.name}-deployment'
  params: {
    location: sqlServerSettings.primarySqlServer.region
    tags: tags

    serverName: sqlServerSettings.primarySqlServer.sqlServer.name

    databaseName: database.name
    skuName: database.skuName
    skuSize: database.skuSize
    skuTier: database.skuTier
  }
  dependsOn: [
    SqlServerDeployment
  ]
}]

module SqlServerFailoverGroupDeployment './resource-files/sql-server-failover-group.bicep' = if (sqlServerSettings.failoverGroup != null) {
  name: 'sql-server-failovergroup-deployment'
  params: {
    tags: tags

    sqlServerFailoverGroupName: sqlServerSettings.failoverGroup.name

    primarySqlServerName: sqlServerSettings.primarySqlServer.sqlServer.name
    secondarySqlServerNames: map(sqlServerSettings.secondarySqlServers, (sqlServer) => sqlServer.sqlServer.name)

    databaseNames: databaseNames

    readWriteEndpointFailoverPolicy: sqlServerSettings.failoverGroup.readWriteEndpointFailoverPolicy
    failoverWithDataLossGracePeriodMinutes: sqlServerSettings.failoverGroup.failoverWithDataLossGracePeriodMinutes
  }

  dependsOn: [
    SqlServerDeployment
    SqlServerDatabaseDeployments
  ]
}

module SqlServerPrivateEndpointDeployment './resource-files/sql-server-private-endpoint.bicep' = [for sqlServer in sqlServers: {
  name: '${sqlServer.sqlServer.name}-private-endpoint-deployment'
  params: {
    tags: tags

    sqlServerName: sqlServer.sqlServer.name
    vNet: sqlServer.vNet

    sqlServerPrivateEndpointName: sqlServer.privateEndpoint.name
    sqlServerPrivateEndpointIpConfigurationName: sqlServer.privateEndpoint.ipConfigurationName
    sqlServerPrivateEndpointIpConfigurationPrivateIpAddress: sqlServer.privateEndpoint.ipConfigurationPrivateIpAddress
    sqlServerPrivateEndpointCustomDnsConfigIpAddress: sqlServer.privateEndpoint.customDnsConfigIpAddress
  }
  dependsOn: [
    SqlServerDeployment
    SqlServerDatabaseDeployments
  ]
}]

module PrivateDnsZoneDeployment './resource-files/private-dns-zone.bicep' = if (sqlServerSettings.privateDnsZone != null) {
  name: 'private-dns-zone-deployment'
  params: {
    tags: tags

    privateDnsZone: privateDnsZone
  }
  dependsOn: [
    SqlServerDeployment
    SqlServerDatabaseDeployments
    SqlServerPrivateEndpointDeployment
  ]
}
