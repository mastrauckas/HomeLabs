using 'main.bicep'

param tags = {
  Project: 'PRJ00004A'
  Purpose: 'Learning'
}

param managedKubeCluster = {
  name: 'aks-test-cluster'
  region: 'eastus'
  kubernetesVersion: '1.29.2'
  dnsPrefix: 'maa-dns'
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  enableRBAC: true
  nodeResourceGroup: 'aks-test-cluster-managed-rg'
  disableLocalAccounts: false
  aadProfile: null
  autoUpgradeProfile: {
    // upgradeChannel: 'stable'
    upgradeChannel: 'patch'
    nodeOSUpgradeChannel: 'NodeImage'
  }
  identity: {
    type: 'SystemAssigned'
  }
  extendedLocation: null
  agentPoolProfiles: [
    {
      name: 'snodepool'
      mode: 'System'
      count: 1 // Number of agents (VMs) to host docker containers. 
      // Allowed values must be in the range of 0 to 1000 (inclusive) 
      // for user pools and in the range of 1 to 1000 (inclusive) 
      // for system pools. The default value is 1.
      minCount: 1 // The minimum number of nodes for auto-scaling
      maxCount: 1 // The maximum number of nodes for auto-scaling
      maxPods: 100
      vmSize: 'Standard_D2s_v3'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets'
      enableAutoScaling: true
      enableNodePublicIP: false
      availabilityZones: [
        '1'
        '2'
        '3'
      ]
      tags: {}
      nodeLabels: {}
      nodeTaints: []
    }
    {
      name: 'unodepool'
      mode: 'User'
      count: 1 // Number of agents (VMs) to host docker containers. 
      // Allowed values must be in the range of 0 to 1000 (inclusive) 
      // for user pools and in the range of 1 to 1000 (inclusive) 
      // for system pools. The default value is 1.
      minCount: 1 // The minimum number of nodes for auto-scaling
      maxCount: 1 // The maximum number of nodes for auto-scaling
      maxPods: 100
      vmSize: 'Standard_D2s_v3'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets'
      enableAutoScaling: true
      enableNodePublicIP: false
      availabilityZones: [
        '1'
        '2'
        '3'
      ]
      tags: {}
      nodeLabels: {}
      nodeTaints: []
    }
  ]
  linuxProfile: null
  apiServerAccessProfile: {
    authorizedIPRanges: null
    enablePrivateCluster: null
  }
  addonProfiles: {
    azurepolicy: null
    azureKeyvaultSecretsProvider: null
  }
  diskEncryptionSetID: null
  networkProfile: {
    networkPlugin: 'azure'
    networkPluginMode: 'Overlay'
    loadBalancerSku: 'Standard'
    networkPolicy: ''
    serviceCidr: ''
    dnsServiceIP: ''
  }
  supportPlan: 'KubernetesOfficial'
}
