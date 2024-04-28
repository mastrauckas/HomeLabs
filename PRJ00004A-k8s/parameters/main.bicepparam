using '../main.bicep'

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
  nodeResourceGroup: 'k8s-testing-managed-rg'
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
      name: 'systempool1'
      mode: 'System'
      count: 2 // This is how many nodes/vms to start with.
      minCount: 2 // The minimum number of nodes/vms for auto-scaling
      maxCount: 5 // The maximum number of nodes/vms for auto-scaling
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
      name: 'userpool1'
      mode: 'User'
      count: 2 // This is how many nodes/vms to start with.
      minCount: 2 // The minimum number of nodes/vms for auto-scaling
      maxCount: 5 // The maximum number of nodes/vms for auto-scaling
      maxPods: 100
      vmSize: 'Standard_B2s'
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
