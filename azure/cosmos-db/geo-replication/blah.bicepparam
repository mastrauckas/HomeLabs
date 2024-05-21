param privateEndpoints = [
  {
    name: '${environmentPrefix}-k8s-cosmos-${primaryRegion}-private-endpoint'
    vNetResourceGroup: privateEndpointResourceRoute
    vNetName: vNetName
    subnetName: subnetName
    region: primaryRegion

    ipConfigurations: ipConfigurations

    customNetworkInterfaceName: '${environmentPrefix}-k8s-cosmos-${primaryRegion}-private-endpoint-nic'

    privateLinkServiceConnections: [
      {
        name: '${environmentPrefix}-k8s-cosmos-${primaryRegion}-private-endpoint-${primaryRegion}-link-connection'
        groupIds: [
          'Sql'
        ]
      }
    ]

    privateDnsZone: {
      name: 'privatelink.documents.azure.com'

      privateDnsZonGroups: [
        {
          name: '${environmentPrefix}-k8s-cosmos-${primaryRegion}-private-endpoint-zone-group'
          privateDnsZoneConfigName: '${environmentPrefix}-k8s-zone-group-configuration-${primaryRegion}'
        }
      ]
    }

    privateDnsVNetLinks: [
      {
        name: '${environmentPrefix}-k8s-cosmos-private-dns-zone-link'
        registrationEnabled: false
      }
    ]
  }
]
