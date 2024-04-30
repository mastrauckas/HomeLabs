param location string
param tags object

param publicIpAddressName string
param publicIpAddressVersion string
param publicIpAllocationMethod string
param publicIpAddressSku string
param publicIpAddressTier string

resource PublicIpAddress 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: publicIpAddressName
  location: location
  tags: tags
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
    publicIPAddressVersion: publicIpAddressVersion
    idleTimeoutInMinutes: 4
  }
  sku: {
    name: publicIpAddressSku
    tier: publicIpAddressTier
  }
}
