param tags object
param managedKubeCluster object
param userAssignedManagedIdentities array
#disable-next-line no-unused-params
param region string

module KubeDeployment './modules/aks.bicep' = {
  name: 'KubeDeployment'
  params: {
    tags: tags
    managedKubeCluster: managedKubeCluster
  }
}

module UserAssignedManagedIdentityDeployment './modules/user-assigned-managed-identity.bicep' = [
  for userAssignedManagedIdentity in userAssignedManagedIdentities: {
    name: userAssignedManagedIdentity.name
    params: {
      tags: tags
      userAssignedManagedIdentity: userAssignedManagedIdentity
      issuerURL: KubeDeployment.outputs.issuerURL
    }
    dependsOn: [
      KubeDeployment
    ]
  }
]
