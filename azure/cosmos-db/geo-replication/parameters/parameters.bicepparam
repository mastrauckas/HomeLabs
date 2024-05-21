using '../main.bicep'

param myIpAddress = ''
param primaryRegion = ''

var primaryVmRegion = primaryRegion

var enableFreeTier = true // This can only be enabled once per subscription.
var accountThroughput = 2000
var containerThroughput = 400
var databaseThroughput = null

var consistencyPolicy = {
  // defaultConsistencyLevel: 'Strong'
  defaultConsistencyLevel: 'ConsistentPrefix'
  maxIntervalInSeconds: 0
  maxStalenessPrefix: 0
}

var regions = [
  {
    failoverPriority: 0
    locationName: 'westus'
    isZoneRedundant: false
  }
  {
    failoverPriority: 1
    locationName: primaryRegion
    isZoneRedundant: false
  }
  // {
  //   failoverPriority: 1
  //   locationName: 'westus3'
  //   isZoneRedundant: true
  // }
  // {
  //   failoverPriority: 2
  //   locationName: 'centralus'
  //   isZoneRedundant: false
  // }
  {
    failoverPriority: 3
    locationName: 'southcentralus'
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
    machinesCounter
  ]
}

param ipAddresses = [
  {
    name: '${primaryVmRegion}-vm-ip-address'
    region: primaryVmRegion
    version: 'IPv4'
    allocationMethod: 'Static'
    sku: 'Standard'
    tier: 'Regional'
  }
]

param vNets = [
  {
    name: '${primaryVmRegion}-vm-vnet'
    region: primaryVmRegion
    addressPrefixes: [
      '10.0.100.0/24'
    ]
    subnets: [
      {
        name: '${primaryVmRegion}-vm-subnet'
        addressPrefix: '10.0.100.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
      }
    ]
  }
]

param virtualMachines = [
  {
    name: '${primaryVmRegion}-vm'
    region: primaryVmRegion
    adminUserName: 'michael'
    adminPassword: 'Testing12345$'
    computerName: '${primaryVmRegion}-vm'
    timeZone: 'US Eastern Standard Time'
    licenseType: 'Windows_Server'
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2022-datacenter-azure-edition'
    version: 'latest'
    vmSize: 'Standard_DS1_v2'
    okDiskName: '${primaryVmRegion}-vm-disk'
    caching: 'ReadWrite'
    createOption: 'FromImage'
    storageAccountType: 'Premium_LRS'
    diskSizeGB: 128
    networkInterface: {
      name: '${primaryVmRegion}-vm-nic'
      dnsServers: []
      internalDnsNameLabel: null
      networkSecurityGroup: {
        name: '${primaryVmRegion}-vm-nsg'
        rules: [
          {
            name: 'Allow-RDP-All'
            direction: 'Inbound'
            priority: 100
            access: 'Allow'
            destinationPortRange: '3389'
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
          }
        ]
      }
      ipConfigurations: [
        {
          name: '${primaryVmRegion}-vm-configuration'
          primary: true
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.100.4'
          privateIPAddressVersion: 'IPv4'
          publicIpAddressDeleteOption: 'Delete'
          vNet: {
            name: '${primaryVmRegion}-vm-vnet'
            subnetName: '${primaryVmRegion}-vm-subnet'
            region: primaryVmRegion
          }
          publicIpAddress: {
            name: '${primaryVmRegion}-vm-ip-address'
            version: 'IPv4'
            allocationMethod: 'Static'
            sku: 'Standard'
            tier: 'Regional'
          }
        }
      ]
    }
    zones: [
      '1'
    ]
  }
]
