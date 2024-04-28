param location string
param tags object

param serverName string

param adminLoginName string
@secure()
param adminPassword string

param minimalTlsVersion string

resource SqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverName
  location: location
  tags: tags
  properties: {
    administratorLogin: adminLoginName
    administratorLoginPassword: adminPassword
    minimalTlsVersion: minimalTlsVersion
  }
}
