param tags object
param vNetSettings object

var vNets = vNetSettings.vNets

module vNetDeployments './resource-files/vnet.bicep' = [for vNet in vNets: {
  name: '${vNet.name}-deployment'
  params: {
    location: vNet.region
    tags: tags

    vNetName: vNet.name
    addressPrefixes: vNet.addressPrefixes
    subnets: vNet.subnets
  }
}]
