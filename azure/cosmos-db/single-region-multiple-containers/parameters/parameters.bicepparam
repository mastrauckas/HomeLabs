using '../main.bicep'

param myIpAddress = ''
param primaryRegion = ''

var enableFreeTier = true // This can only be enabled once per subscription.

var accountThroughput = 800
var databaseThroughput = 800

var containerOneThroughput = null
var containerTwoThroughput = null

var consistencyPolicy = {
  defaultConsistencyLevel: 'Strong'
  maxIntervalInSeconds: 0
  maxStalenessPrefix: 0
}

var regions = [
  {
    failoverPriority: 0
    locationName: primaryRegion
    isZoneRedundant: false
  }
]

// Whitelist my ip addres and the Azure Portals IP Addresses.
// Shows Portals IP Addresses https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall#allow-requests-from-the-azure-portal
var ipAddressesToAdd = [
  {
    ipAddressOrRange: myIpAddress
  }
  {
    ipAddressOrRange: '104.42.195.92'
  }
  {
    ipAddressOrRange: '40.76.54.131'
  }
  {
    ipAddressOrRange: '52.176.6.30'
  }
  {
    ipAddressOrRange: '52.169.50.45'
  }
  {
    ipAddressOrRange: '52.187.184.26'
  }
  {
    ipAddressOrRange: '13.88.56.148'
  }
  {
    ipAddressOrRange: '40.91.218.243'
  }
  {
    ipAddressOrRange: '13.91.105.215'
  }
  {
    ipAddressOrRange: '4.210.172.107'
  }
]

param tags = {}

param workspace = {
  name: 'cosmos-testing-db-workspace'
  region: primaryRegion
  retentionInDays: 30
  publicNetworkAccessForIngestion: 'Enabled'
  publicNetworkAccessForQuery: 'Enabled'
  sku: {
    name: 'PerGB2018'
    capacityReservationLevel: null
  }
  workspaceCapping: {
    dailyQuotaGb: 1
  }
}

param workspaceDiagnosticSettings = {
  name: 'Cosmos DB Diagnostic setting'
  logs: [
    {
      category: 'DataPlaneRequests'
      enabled: true
    }
    {
      category: 'QueryRuntimeStatistics'
      enabled: true
    }
    {
      category: 'PartitionKeyStatistics'
      enabled: true
    }
    {
      category: 'PartitionKeyRUConsumption'
      enabled: true
    }
    {
      category: 'ControlPlaneRequests'
      enabled: true
    }
  ]
  metrics: [
    {
      category: 'AllMetrics'
      enabled: true
    }
  ]
}

param applicationInsights = {
  name: 'cosmos-testing-db-application-insights'
  region: primaryRegion
  kind: 'cosmos-db'
  applicationType: 'web'
}

var containerOne = {
  name: 'Container1'
  autoscaleSettings: null
  throughput: containerOneThroughput
  defaultTtl: -1

  materializedViewDefinition: {}
  restoreParameters: []
  partitionKey: {
    paths: [
      '/containerOneId'
    ]
    kind: 'Hash'
  }
  uniqueKeyPolicy: {}
  indexingPolicy: {
    indexingMode: 'consistent'
    includedPaths: [
      {
        path: '/containerOneId/?'
      }
    ]
    excludedPaths: [
      {
        path: '/*'
      }
    ]
    compositeIndexes: []
    spatialIndexes: []
  }
}

var containerTwo = {
  name: 'Container2'
  autoscaleSettings: null
  throughput: containerTwoThroughput
  defaultTtl: -1

  materializedViewDefinition: {}
  restoreParameters: []
  partitionKey: {
    paths: [
      '/containerTwoId'
    ]
    kind: 'Hash'
  }
  uniqueKeyPolicy: {}
  indexingPolicy: {
    indexingMode: 'consistent'
    includedPaths: [
      {
        path: '/containerTwoId/?'
      }
    ]
    excludedPaths: [
      {
        path: '/*'
      }
    ]
    compositeIndexes: []
    spatialIndexes: []
  }
}

param cosmosAccount = {
  name: 'cosmos-testing-db'
  region: primaryRegion
  kind: 'GlobalDocumentDB'
  databaseAccountOfferType: 'Standard'
  isVirtualNetworkFilterEnabled: false
  enableAnalyticalStorage: false
  enableAutomaticFailover: false
  minimalTlsVersion: 'Tls12'
  enableMultipleWriteLocations: false
  enableFreeTier: enableFreeTier
  disableKeyBasedMetadataWriteAccess: true

  identity: {
    type: 'SystemAssigned'
  }

  consistencyPolicy: consistencyPolicy

  backupPolicy: {
    type: 'Periodic'
    periodicModeProperties: {
      backupIntervalInMinutes: 240
      backupRetentionIntervalInHours: 8
      backupStorageRedundancy: 'Geo'
    }
  }

  capacity: {
    totalThroughputLimit: accountThroughput
  }

  regions: regions

  capabilities: []

  virtualNetworkRules: []

  ipRules: ipAddressesToAdd

  database: {
    name: 'Testing'
    createMode: 'Default'
    restoreParameters: null
    autoscaleSettings: null
    throughput: databaseThroughput
  }

  containers: [
    containerOne
    containerTwo
  ]
}
