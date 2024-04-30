param tags object
param privateDnsZoneLinkSettings object

var privateDnsZoneVirtualNetworkLinks = privateDnsZoneLinkSettings.privateDnsZoneVirtualNetworkLinks

module PrivateDnsZoneLinks './resource-files/private-dns-zone-link.bicep' = [for privateDnsZoneVirtualNetworkLink in privateDnsZoneVirtualNetworkLinks: {
  name: '${privateDnsZoneVirtualNetworkLink.name}-deployment'
  params: {
    tags: tags

    privateDnsZoneVirtualLinkName: privateDnsZoneVirtualNetworkLink.name

    vNetName: privateDnsZoneVirtualNetworkLink.vNetName
    privateDnsZoneName: privateDnsZoneVirtualNetworkLink.privateDnsZoneName
    registrationEnabled: privateDnsZoneVirtualNetworkLink.registrationEnabled
  }
}]
