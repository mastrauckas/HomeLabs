param tags object

param sqlServerFailoverGroupName string

param primarySqlServerName string
param secondarySqlServerNames array

param databaseNames string[]

param readWriteEndpointFailoverPolicy string
param failoverWithDataLossGracePeriodMinutes int

resource SecondarySqlServers 'Microsoft.Sql/servers@2022-05-01-preview' existing = [for secondarySqlServerName in secondarySqlServerNames: {
  name: secondarySqlServerName
}]

resource sqlServerFailoverGroup 'Microsoft.Sql/servers/failoverGroups@2022-05-01-preview' = {
  name: '${primarySqlServerName}/${sqlServerFailoverGroupName}'
  tags: tags

  properties: {
    databases: [for dataBaseName in databaseNames: resourceId('Microsoft.Sql/servers/databases', primarySqlServerName, dataBaseName)]
    readWriteEndpoint: {
      failoverPolicy: readWriteEndpointFailoverPolicy
      failoverWithDataLossGracePeriodMinutes: failoverWithDataLossGracePeriodMinutes
    }
    partnerServers: [for (secondarySqlServerName, index) in secondarySqlServerNames: {
      id: SecondarySqlServers[index].id
    }]
  }
}
