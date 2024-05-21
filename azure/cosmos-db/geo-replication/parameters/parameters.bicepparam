using '../main.bicep'

param myIpAddress = ''
param primaryRegion = ''

var consistencyPolicy = {
  // defaultConsistencyLevel: 'Strong'
  defaultConsistencyLevel: 'ConsistentPrefix'
  maxIntervalInSeconds: 0
  maxStalenessPrefix: 0
}

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

// param ipAddresses = regionResourceTemplates.ipAddressesTemplate

// param ipAddresses = []
//   {
//     name: '${primaryVmRegion}-vm-ip-address'
//     region: primaryVmRegion
//     version: 'IPv4'
//     allocationMethod: 'Static'
//     sku: 'Standard'
//     tier: 'Regional'
//   }
//   {
//     name: 'southcentralus-vm-ip-address'
//     region: 'southcentralus'
//     version: 'IPv4'
//     allocationMethod: 'Static'
//     sku: 'Standard'
//     tier: 'Regional'
//   }
//   {
//     name: 'westus3-vm-ip-address'
//     region: 'westus3'
//     version: 'IPv4'
//     allocationMethod: 'Static'
//     sku: 'Standard'
//     tier: 'Regional'
//   }
//   {
//     name: 'northeurope-vm-ip-address'
//     region: 'northeurope'
//     version: 'IPv4'
//     allocationMethod: 'Static'
//     sku: 'Standard'
//     tier: 'Regional'
//   }
//   {
//     name: 'westeurope-vm-ip-address'
//     region: 'westeurope'
//     version: 'IPv4'
//     allocationMethod: 'Static'
//     sku: 'Standard'
//     tier: 'Regional'
//   }
//   {
//     name: 'swedencentral-vm-ip-address'
//     region: 'swedencentral'
//     version: 'IPv4'
//     allocationMethod: 'Static'
//     sku: 'Standard'
//     tier: 'Regional'
//   }
// ]

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

param vNets = map(cosmosRegions, (cosmosRegion, index) => {
  name: '${cosmosRegion.locationName}-vm-vnet'
  region: cosmosRegion.locationName
  addressPrefixes: [
    '10.0.${1 * (index + 1)}.0/24'
  ]
  subnets: [
    {
      name: '${cosmosRegion.locationName}-vm-subnet'
      addressPrefix: '10.0.${1 * (index + 1)}.0/24'
      privateEndpointNetworkPolicies: 'Disabled'
      privateLinkServiceNetworkPolicies: 'Disabled'
    }
  ]
})

param ipAddresses = map(cosmosRegions, cosmosRegion => {
  name: '${cosmosRegion.locationName}-vm-ip-address'
  region: cosmosRegion.locationName
  version: 'IPv4'
  allocationMethod: 'Static'
  sku: 'Standard'
  tier: 'Regional'
})

param vms = map(cosmosRegions, (cosmosRegion, index) => {
  name: '${cosmosRegion.locationName}-vm'
  region: cosmosRegion.locationName
  adminUserName: 'michael'
  adminPassword: 'Testing12345$'
  computerName: 'vm-${index}'
  timeZone: 'US Eastern Standard Time'
  licenseType: 'Windows_Server'
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
  vmSize: 'Standard_DS1_v2'
  okDiskName: '${cosmosRegion.locationName}-vm-disk'
  caching: 'ReadWrite'
  createOption: 'FromImage'
  storageAccountType: 'Premium_LRS'
  diskSizeGB: 128
  networkInterface: {
    name: '${cosmosRegion.locationName}-vm-nic'
    dnsServers: []
    internalDnsNameLabel: null
    networkSecurityGroup: {
      name: '${cosmosRegion.locationName}-vm-nsg'
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
        name: '${cosmosRegion.locationName}-vm-configuration'
        primary: true
        privateIPAllocationMethod: 'Dynamic'
        privateIPAddress: null
        privateIPAddressVersion: 'IPv4'
        publicIpAddressDeleteOption: 'Delete'
        vNet: {
          name: '${cosmosRegion.locationName}-vm-vnet'
          subnetName: '${cosmosRegion.locationName}-vm-subnet'
          region: cosmosRegion.locationName
        }
        publicIpAddress: {
          name: '${cosmosRegion.locationName}-vm-ip-address'
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
})

param privateEndpoints = map(vNets, vNet => {
  name: 'vm-k8s-cosmos-${vNet.region}-private-endpoint'
  vNetName: vNet.name
  subnetName: vNet.subnets[0]
  region: vNet.region

  ipConfigurations: []

  customNetworkInterfaceName: 'vm-k8s-cosmos-${vNet.region}-private-endpoint-nic'

  privateLinkServiceConnections: [
    {
      name: 'vm-k8s-cosmos-${vNet.region}-private-endpoint-${vNet.region}-link-connection'
      groupIds: [
        'Sql'
      ]
    }
  ]

  privateDnsZone: {
    name: 'privatelink.documents.azure.com'

    privateDnsZonGroups: [
      {
        name: 'vm-k8s-cosmos-${vNet.region}-private-endpoint-zone-group'
        privateDnsZoneConfigName: 'vm-k8s-zone-group-configuration-${vNet.region}'
      }
    ]
  }

  privateDnsVNetLinks: [
    {
      name: 'vm-k8s-cosmos-private-dns-zone-link'
      registrationEnabled: false
    }
  ]
})
