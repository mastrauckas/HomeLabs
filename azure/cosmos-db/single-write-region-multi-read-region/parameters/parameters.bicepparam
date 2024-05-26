using '../main.bicep'

param myIpAddress = ''
param primaryRegion = ''

var consistencyPolicy = {
  // defaultConsistencyLevel: 'Strong'
  defaultConsistencyLevel: 'ConsistentPrefix'
  maxIntervalInSeconds: 0
  maxStalenessPrefix: 0
}

var enableMultipleWriteLocations = false

var cosmosRegions = [
  {
    failoverPriority: 0
    locationName: primaryRegion
    isZoneRedundant: false
  }
  {
    failoverPriority: 1
    locationName: 'centralus'
    isZoneRedundant: false
  }
  {
    failoverPriority: 2
    locationName: 'westus3'
    isZoneRedundant: false
  }
  {
    failoverPriority: 3
    locationName: 'northeurope'
    isZoneRedundant: false
  }
  {
    failoverPriority: 4
    locationName: 'uksouth'
    isZoneRedundant: false
  }
  {
    failoverPriority: 5
    locationName: 'swedencentral'
    isZoneRedundant: false
  }
  // {
  //   failoverPriority: 1
  //   locationName: 
  //   isZoneRedundant: true
  // }
  // {
  //   failoverPriority: 2
  //   locationName: 'southcentralus'
  //   isZoneRedundant: false
  // }
]

var enableFreeTier = true // This can only be enabled once per subscription.

var containerThroughput = 400
var accountThroughput = length(cosmosRegions) * containerThroughput
var databaseThroughput = null

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

var machinesCounter = {
  name: 'Machines'
  autoscaleSettings: null
  throughput: containerThroughput
  defaultTtl: -1

  materializedViewDefinition: {}
  restoreParameters: []
  partitionKey: {
    paths: [
      '/machineName'
    ]
    kind: 'Hash'
  }
  uniqueKeyPolicy: {}
  indexingPolicy: {
    indexingMode: 'consistent'
    includedPaths: [
      {
        path: '/machineName/?'
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
  enableMultipleWriteLocations: enableMultipleWriteLocations
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

  regions: cosmosRegions

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
    machinesCounter
  ]
}
