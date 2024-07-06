param tags object
param managedKubeCluster object
param userAssignedIdentities array
#disable-next-line no-unused-params
param region string

module KubeDeployment './modules/aks.bicep' = {
  name: 'KubeDeployment'
  params: {
    tags: tags
    managedKubeCluster: managedKubeCluster
  }
}
