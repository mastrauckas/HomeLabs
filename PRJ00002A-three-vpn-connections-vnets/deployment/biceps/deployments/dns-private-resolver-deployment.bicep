param tags object
param privateDnsResolverSettings object

var privateDnsResolver = privateDnsResolverSettings.privateDnsResolver

module PrivateDnsResolver './resource-files/private-dns-resolver.bicep' = if (privateDnsResolver != null) {
  name: 'private-dns-resolver-deployment'
  params: {
    location: privateDnsResolver.region
    tags: tags

    dnsResolverName: privateDnsResolver.name
    vNetName: privateDnsResolver.vNetName

    inboundDnsResolverEndpoints: privateDnsResolver.inboundDnsResolverEndpoints
  }
}
