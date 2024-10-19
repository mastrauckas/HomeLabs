param tags object
param managedKubeCluster object

resource aks 'Microsoft.ContainerService/managedClusters@2024-01-02-preview' = {
  name: managedKubeCluster.name
  tags: tags
  location: managedKubeCluster.region
  sku: managedKubeCluster.sku
  identity: managedKubeCluster.identity
  extendedLocation: managedKubeCluster.extendedLocation
  properties: {
    kubernetesVersion: managedKubeCluster.kubernetesVersion
    agentPoolProfiles: managedKubeCluster.agentPoolProfiles
    enableRBAC: managedKubeCluster.enableRBAC
    nodeResourceGroup: managedKubeCluster.nodeResourceGroup
    disableLocalAccounts: managedKubeCluster.disableLocalAccounts
    dnsPrefix: managedKubeCluster.dnsPrefix
    aadProfile: managedKubeCluster.aadProfile
    autoUpgradeProfile: managedKubeCluster.autoUpgradeProfile
    linuxProfile: managedKubeCluster.linuxProfile
    apiServerAccessProfile: managedKubeCluster.apiServerAccessProfile
    addonProfiles: managedKubeCluster.addonProfiles
    diskEncryptionSetID: managedKubeCluster.diskEncryptionSetID
    networkProfile: managedKubeCluster.networkProfile
    supportPlan: managedKubeCluster.supportPlan
    azureMonitorProfile: managedKubeCluster.azureMonitorProfile
    oidcIssuerProfile: managedKubeCluster.oidcIssuerProfile
    securityProfile: managedKubeCluster.securityProfile
  }
}
