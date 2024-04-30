param location string
param tags object

param vmName string
param zones string[]
param vmSize string

param adminUserName string
@secure()
param adminPassword string

param computerName string
param timeZone string
param licenseType string
param publisher string
param offer string
param sku string
param version string
param okDiskName string
param caching string
param createOption string
param storageAccountType string
param diskSizeGB int
param networkInterface object

var networkSecurityGroup = networkInterface.networkSecurityGroup
var ipConfigurations = networkInterface.ipConfigurations

resource VNets 'Microsoft.Network/virtualNetworks@2023-04-01' existing = [for ipConfiguration in ipConfigurations: {
  name: ipConfiguration.vNet.name
}]

resource PublicIpAddresses 'Microsoft.Network/publicIPAddresses@2023-04-01' existing = [for ipConfiguration in ipConfigurations: {
  name: ipConfiguration.publicIpAddress.name
}]

resource NetworkSecurityGroups 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: networkSecurityGroup.name
  location: location
  properties: {
    securityRules: map(networkSecurityGroup.rules, (rule) => {
        name: networkSecurityGroup.name
        properties: {
          priority: rule.priority
          access: rule.access
          direction: rule.direction
          destinationPortRange: rule.destinationPortRange
          protocol: rule.protocol
          sourcePortRange: rule.sourcePortRange
          sourceAddressPrefix: rule.sourceAddressPrefix
          destinationAddressPrefix: rule.destinationAddressPrefix
        }
      })
  }
}

resource VmNetworkInterface 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: networkInterface.name
  location: location
  tags: tags

  properties: {
    networkSecurityGroup: {
      id: NetworkSecurityGroups.id
    }
    dnsSettings: {
      dnsServers: networkInterface.dnsServers
      internalDnsNameLabel: networkInterface.internalDnsNameLabel
    }
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurations: {
      name: ipConfiguration.name
      properties: {
        primary: ipConfiguration.primary
        privateIPAllocationMethod: ipConfiguration.privateIPAllocationMethod
        privateIPAddress: ipConfiguration.privateIPAddress
        privateIPAddressVersion: ipConfiguration.privateIPAddressVersion
        publicIPAddress: {
          id: PublicIpAddresses[index].id
          properties: {
            deleteOption: ipConfiguration.publicIpAddressDeleteOption
          }
        }
        subnet: {
          id: filter(VNets[index].properties.subnets, sn => sn.name == ipConfiguration.vNet.subnetName)[0].id
        }
      }
    }]
  }
}

resource Vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
  tags: tags
  zones: zones
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      adminUsername: adminUserName
      adminPassword: adminPassword
      computerName: computerName
      windowsConfiguration: {
        timeZone: timeZone
        enableAutomaticUpdates: true
        patchSettings: {
          enableHotpatching: false
          patchMode: 'AutomaticByOS'
        }
      }
    }
    licenseType: licenseType
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
        publisher: publisher
        offer: offer
        sku: sku
        version: version
      }

      osDisk: {
        name: okDiskName
        caching: caching
        createOption: createOption
        managedDisk: {
          // storageAccountType: 'Premium_LRS'
          // storageAccountType: 'StandardSSD_LRS'
          storageAccountType: storageAccountType
        }
        deleteOption: 'Delete'
        diskSizeGB: diskSizeGB
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
