param tags object
param userAssignedManagedIdentity object
param issuerURL string

resource UserAssignedManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: userAssignedManagedIdentity.name
  location: userAssignedManagedIdentity.region
  tags: tags
}

resource FederatedIdentityCredentials 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  name: userAssignedManagedIdentity.federatedIdentityCredential.name
  parent: UserAssignedManagedIdentity
  properties: {
    audiences: userAssignedManagedIdentity.federatedIdentityCredential.audiences
    issuer: issuerURL
    subject: userAssignedManagedIdentity.federatedIdentityCredential.subject
  }
}
