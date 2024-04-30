param tags object
param virtualMachineSettings object

var virtualMachines = virtualMachineSettings.virtualMachines

var publicIpAddresses = flatten(map(virtualMachines, (virtualMachine) => 
   map(virtualMachine.networkInterface.ipConfigurations, (ipConfiguration) => {
      name: ipConfiguration.publicIpAddress.name
      version: ipConfiguration.publicIpAddress.version
      allocationMethod: ipConfiguration.publicIpAddress.allocationMethod
      sku: ipConfiguration.publicIpAddress.sku
      tier: ipConfiguration.publicIpAddress.tier
      region: virtualMachine.region
    })
))

module VmIpAddressDeployments './resource-files/ip-address.bicep' = [for publicIpAddress in publicIpAddresses: {
  name: '${publicIpAddress.name}-deployment'
  params: {
    location: publicIpAddress.region
    tags: tags

    publicIpAddressName: publicIpAddress.name
    publicIpAddressVersion: publicIpAddress.version
    publicIpAllocationMethod: publicIpAddress.allocationMethod
    publicIpAddressSku: publicIpAddress.sku
    publicIpAddressTier: publicIpAddress.tier
  }
}]

module VmDeployment './resource-files/vm.bicep' = [for virtualMachine in virtualMachines: {
  name: '${virtualMachine.name}-deployment'
  params: {
    location: virtualMachine.region
    tags: tags

    vmName: virtualMachine.name
    vmSize: virtualMachine.vmSize

    adminUserName: virtualMachine.adminUserName
    adminPassword: virtualMachine.adminPassword

    computerName: virtualMachine.computerName
    zones: virtualMachine.zones
    timeZone: virtualMachine.timeZone
    licenseType: virtualMachine.licenseType
    publisher: virtualMachine.publisher
    offer: virtualMachine.offer
    sku: virtualMachine.sku
    version: virtualMachine.version

    okDiskName: virtualMachine.okDiskName
    caching: virtualMachine.caching
    createOption: virtualMachine.createOption
    storageAccountType: virtualMachine.storageAccountType
    diskSizeGB: virtualMachine.diskSizeGB

    networkInterface: virtualMachine.networkInterface
  }

  dependsOn: [
    VmIpAddressDeployments
  ]
}]
