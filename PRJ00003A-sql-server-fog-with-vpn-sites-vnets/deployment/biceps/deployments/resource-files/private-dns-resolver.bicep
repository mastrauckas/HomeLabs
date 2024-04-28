param location string
param tags object

param dnsResolverName string
param vNetName string

param inboundDnsResolverEndpoints object[]

resource VNet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vNetName
}

resource DnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: dnsResolverName
  location: location
  tags: tags
  properties: {
    virtualNetwork: {
      id: VNet.id
    }
  }
}

resource DnsResolverInboundEndpoints 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = [for inboundDnsResolverEndpoint in inboundDnsResolverEndpoints: {
  parent: DnsResolver
  name: inboundDnsResolverEndpoint.name
  location: location
  properties: {
    ipConfigurations: [for ipConfiguration in inboundDnsResolverEndpoint.ipConfigurations: {
      privateIpAddress: ipConfiguration.privateIpAddress
      privateIpAllocationMethod: ipConfiguration.privateIpAllocationMethod
      subnet: {
        id: filter(VNet.properties.subnets, sn => sn.name == ipConfiguration.subnetName)[0].id
      }
    }]
  }
}]
