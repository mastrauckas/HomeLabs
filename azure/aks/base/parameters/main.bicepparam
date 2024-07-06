using '../main.bicep'

param region = ''

param tags = {
  Project: 'PRJ00004A'
  Purpose: 'Learning'
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/2023-01-02-preview/managedclusters?pivots=deployment-language-bicep
param managedKubeCluster = {
  name: 'aks-test-cluster-${region}'
  region: region
  kubernetesVersion: '1.29.2'
  dnsPrefix: 'maa-dns'
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  enableRBAC: true
  nodeResourceGroup: 'k8s-testing-cluster-managed-${region}-rg'
  disableLocalAccounts: false
  aadProfile: null
  autoUpgradeProfile: {
    upgradeChannel: 'patch' // Values can be none, patch, rapid, stable and node-image
    nodeOSUpgradeChannel: 'NodeImage' // Values can be None, Unmanaged, SecurityPatch and NodeImage
  }
  identity: {
    type: 'SystemAssigned'
  }
  extendedLocation: null
  agentPoolProfiles: [
    {
      name: 'systempool1'
      mode: 'System'
      count: 1 // This is how many nodes/vms to start with.
      minCount: 1 // The minimum number of nodes/vms for auto-scaling
      maxCount: 5 // The maximum number of nodes/vms for auto-scaling
      maxPods: 100
      messageOfTheDay: null
      vmSize: 'Standard_D2s_v3'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets'
      enableAutoScaling: true
      scaleSetPriority: 'Regular' // Values Regular and Spot
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
      count: 1 // This is how many nodes/vms to start with.
      minCount: 1 // The minimum number of nodes/vms for auto-scaling
      maxCount: 5 // The maximum number of nodes/vms for auto-scaling
      maxPods: 100
      messageOfTheDay: null
      vmSize: 'Standard_B2s'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets'
      enableAutoScaling: true
      scaleSetPriority: 'Regular' // Values Regular and Spot
      enableNodePublicIP: false
      availabilityZones: [
        '1'
        '2'
        '3'
      ]
      tags: {}
      nodeLabels: {}
      nodeTaints: ['dotnet=8.0:NoSchedule']
    }
    {
      name: 'userpool2'
      mode: 'User'
      count: 1 // This is how many nodes/vms to start with.
      minCount: 1 // The minimum number of nodes/vms for auto-scaling
      maxCount: 5 // The maximum number of nodes/vms for auto-scaling
      maxPods: 100
      messageOfTheDay: null
      vmSize: 'Standard_B2s'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets'
      enableAutoScaling: true
      scaleSetPriority: 'Regular' // Values Regular and Spot
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
      name: 'userpool3'
      mode: 'User'
      count: 1 // This is how many nodes/vms to start with.
      minCount: 1 // The minimum number of nodes/vms for auto-scaling
      maxCount: 5 // The maximum number of nodes/vms for auto-scaling
      maxPods: 100
      messageOfTheDay: null
      vmSize: 'Standard_B2s'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets'
      enableAutoScaling: true
      scaleSetPriority: 'Regular' // Values Regular and Spot
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
    authorizedIPRanges: [] //
    enablePrivateCluster: false // This will create a private AKS cluster.
    enablePrivateClusterPublicFQDN: false // Whether to create additional public FQDN for private cluster or not.
    privateDNSZone: null
    subnetId: null
    // disableRunCommand: false
    // enableVnetIntegration: false
  }
  addonProfiles: {
    azurepolicy: null
    azureKeyvaultSecretsProvider: null // Secrets Store  Container Storage Interfac(CSI) Driver
    // azureKeyvaultSecretsProvider: {
    //   enabled: true
    //   secrectStoreConfig: {
    //     enableSecretRotation: false
    //     rotationPollInterval: '2m'
    //   }
    // }
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
  supportPlan: 'KubernetesOfficial' // Values can be AKSLongTermSupport and KubernetesOfficial
  azureMonitorProfile: null //Kube State Metrics for prometheus addon profile for the container service cluster
  oidcIssuerProfile: null // Allows Open ID Connect authorization.
  securityProfile: null // Allows you to enable workloadIdentity.
}
