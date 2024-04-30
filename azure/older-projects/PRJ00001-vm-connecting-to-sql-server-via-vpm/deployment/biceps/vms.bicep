param location string

param sqlServerNetworkName string

// resource ApplicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2022-05-01' = {
//   name: 'vm-network-security-groups'
//   location: location

//   properties: {}
// }

// resource InerfaceSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2022-05-01' = {
//   name: 'interface-network-security-groups'
//   location: location

//   properties: {}
// }

resource SubnetNetworkSecurityGroups 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: 'vm-network-security-groups'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP-All'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource VpnNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: 'vm-network'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.30.0/24'
      ]
    }
    subnets: [
      {
        name: 'vm-subnet'
        properties: {
          addressPrefix: '192.168.30.0/24'
          networkSecurityGroup: {
            id: SubnetNetworkSecurityGroups.id
          }
        }
      }
    ]
  }
}

resource VmPublicIpAddress 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: 'vm-ip-address'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    idleTimeoutInMinutes: 4
  }
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
}

resource VmNetworkInterface 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: 'vm-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'VmIpAddress'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: VmPublicIpAddress.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: VpnNetwork.properties.subnets[0].id
          }
          // networkSecurityGroup: [
          //   {
          //     id: InerfaceSecurityGroup.id
          //     properties: {}
          //   }
          // ]
        }
      }
    ]
  }
}

resource Vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: 'Vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    osProfile: {
      computerName: 'test-computer'
      adminUsername: 'michael'
      adminPassword: 'testing12345$'
      windowsConfiguration: {
        enableAutomaticUpdates: true
        patchSettings: {
          enableHotpatching: false
          patchMode: 'AutomaticByOS'
        }
      }
    }
    licenseType: 'Windows_Server'
    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        name: 'machine_OsDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          // storageAccountType: 'Premium_LRS'
          // storageAccountType: 'StandardSSD_LRS'
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 128
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: VmNetworkInterface.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}

resource SqlServerNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: sqlServerNetworkName
}

resource SqlServerNetworkPeering 'microsoft.network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: VpnNetwork
  name: 'VpnNetworkToSqlServerNetworkLink'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: SqlServerNetwork.id
    }
  }
}
