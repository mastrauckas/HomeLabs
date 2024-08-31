using '../main.bicep'

param region = ''

var clusterName = 'aks-test-cluster'

param tags = {
  Project: 'User Node Pool Only Run User Pods'
  Purpose: 'Learning'
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/2023-01-02-preview/managedclusters?pivots=deployment-language-bicep
param managedKubeCluster = {
  name: clusterName
  region: region
  kubernetesVersion: '1.30.3'
  dnsPrefix: 'maa-dns'
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  enableRBAC: true
  nodeResourceGroup: 'k8s-testing-cluster-managed-rg'
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
      maxPods: 100
      messageOfTheDay: null
      vmSize: 'Standard_D2s_v3'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets' // AvailabilitySet, VirtualMachineScaleSets, VirtualMachines
      enableAutoScaling: false
      scaleSetPriority: 'Regular' // Values Regular and Spot
      enableNodePublicIP: false
      availabilityZones: null
      tags: {}
      nodeLabels: {}
      nodeTaints: [
        'CriticalAddonsOnly=true:NoSchedule' // https://learn.microsoft.com/en-us/azure/aks/use-system-pools?tabs=azure-cli
      ]
    }
  ]
  linuxProfile: null
  apiServerAccessProfile: {
    authorizedIPRanges: [] //
    enablePrivateCluster: false // This will create a private AKS cluster.
    enablePrivateClusterPublicFQDN: false // Whether to create additional public FQDN for private cluster or not.
    privateDNSZone: null
    subnetId: null
  }
  addonProfiles: {
    azurepolicy: null
    azureKeyvaultSecretsProvider: null // Secrets Store  Container Storage Interfac(CSI) Driver
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
