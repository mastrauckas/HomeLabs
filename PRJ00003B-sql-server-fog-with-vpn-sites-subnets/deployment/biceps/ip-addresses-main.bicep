param location string = resourceGroup().location
param tags object

param vpnPublicIpAddressName string
param vpnPublicIpAddressVersion string
param vpnPublicIpAllocationMethod string
param vpnPublicIpAddressSku string
param vpnPublicIpAddressTier string

module VpnIpAddress './deployments/resource-files/ip-address.bicep' = {
  name: 'vpn-ip-address-deployment'
  params: {
    location: location
    tags: tags

    publicIpAddressName: vpnPublicIpAddressName
    publicIpAddressVersion: vpnPublicIpAddressVersion
    publicIpAllocationMethod: vpnPublicIpAllocationMethod
    publicIpAddressSku: vpnPublicIpAddressSku
    publicIpAddressTier: vpnPublicIpAddressTier
  }

}
