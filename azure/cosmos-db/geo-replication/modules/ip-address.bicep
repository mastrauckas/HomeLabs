param location string
param tags object

param name string
param version string
param allocationMethod string
param sku string
param tier string

resource PublicIpAddress 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    publicIPAllocationMethod: allocationMethod
    publicIPAddressVersion: version
    idleTimeoutInMinutes: 4
  }
  sku: {
    name: sku
    tier: tier
  }
}
