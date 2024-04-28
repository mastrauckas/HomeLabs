param tags object
param managedKubeCluster object

module KubeDeployment './modules/aks.bicep' = {
  name: 'KubeDeployment'
  params: {
    tags: tags
    managedKubeCluster: managedKubeCluster
  }
}
