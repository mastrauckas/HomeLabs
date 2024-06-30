using '../main.bicep'

var clusterName = 'aks-test-cluster-${region}'

param region = ''

param tags = {
  Project: 'Prometheus Built In'
  Purpose: 'Learning'
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/2023-01-02-preview/managedclusters?pivots=deployment-language-bicep
param managedKubeCluster = {
  name: clusterName
  region: region
  kubernetesVersion: '1.29.4'
  dnsPrefix: 'dns-maa'
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
      minCount: null
      maxCount: null
      maxPods: 100
      messageOfTheDay: null
      vmSize: 'Standard_D2s_v3'
      osType: 'Linux'
      osDiskSizeGB: 30
      type: 'VirtualMachineScaleSets'
      enableAutoScaling: false
      scaleSetPriority: 'Regular' // Values Regular and Spot
      enableNodePublicIP: false
      availabilityZones: []
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
}

// https://medium.com/microsoftazure/deploying-azure-managed-prometheus-with-azapi-ef17e15acac8

param azureMonitorWorkspace = {
  name: 'azure-monitor-workspace'
  region: region
}

param dataCollectionEndpoints = {
  name: 'prometheus-data-collection-endpoint'
  kind: 'Linux'
  region: region
}

param dataCollectionRuleAssociations = {
  name: 'ContainerInsightsMetricsExtension'
  description: 'Association of data collection rule. Deleting this association will break the prometheus metrics data collection for this AKS Cluster.'
}

param dataCollectionRules = {
  name: 'prometheus-data-collecton-rule'
  dataSources: {
    prometheusForwarder: [
      {
        name: 'PrometheusDataSource'
        streams: [
          'Microsoft-PrometheusMetrics'
        ]
        labelIncludeFilter: {}
      }
    ]
  }
  destinations: null
  // {
  //   monitoringAccounts: [
  //     {
  //       name: 'MonitoringAccount1'
  //       accountResourceId: null // Need to set the Azure Monitor Workspace Id.
  //     }
  //   ]
  // }
  dataFlows: [
    {
      destinations: [
        'MonitoringAccount1'
      ]
      streams: [
        'Microsoft-PrometheusMetrics'
      ]
    }
  ]
}

param prometheusRuleGroups = [
  {
    name: 'prometheus-k8s-recording-rule-group'
    region: region
    description: 'Kubernetes Recording Rules RuleGroup'
    enabled: true
    interval: 'PT1M'
    rules: [
      {
        record: 'node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate'
        expression: 'sum by (cluster, namespace, pod, container) (  irate(container_cpu_usage_seconds_total{job="cadvisor", image!=""}[5m])) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (  1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_working_set_bytes'
        expression: 'container_memory_working_set_bytes{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_rss'
        expression: 'container_memory_rss{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_cache'
        expression: 'container_memory_cache{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_swap'
        expression: 'container_memory_swap{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'cluster:namespace:pod_memory:active:kube_pod_container_resource_requests'
        expression: 'kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~"Pending|Running"} == 1))'
      }
      {
        record: 'namespace_memory:kube_pod_container_resource_requests:sum'
        expression: 'sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~"Pending|Running"} == 1        )    ))'
      }
      {
        record: 'cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests'
        expression: 'kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~"Pending|Running"} == 1))'
      }
      {
        record: 'namespace_cpu:kube_pod_container_resource_requests:sum'
        expression: 'sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~"Pending|Running"} == 1        )    ))'
      }
      {
        record: 'cluster:namespace:pod_memory:active:kube_pod_container_resource_limits'
        expression: 'kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~"Pending|Running"} == 1))'
      }
      {
        record: 'namespace_memory:kube_pod_container_resource_limits:sum'
        expression: 'sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~"Pending|Running"} == 1        )    ))'
      }
      {
        record: 'cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits'
        expression: 'kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) ( (kube_pod_status_phase{phase=~"Pending|Running"} == 1) )'
      }
      {
        record: 'namespace_cpu:kube_pod_container_resource_limits:sum'
        expression: 'sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~"Pending|Running"} == 1        )    ))'
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) (  label_replace(    label_replace(      kube_pod_owner{job="kube-state-metrics", owner_kind="ReplicaSet"},      "replicaset", "$1", "owner_name", "(.*)"    ) * on(replicaset, namespace) group_left(owner_name) topk by(replicaset, namespace) (      1, max by (replicaset, namespace, owner_name) (        kube_replicaset_owner{job="kube-state-metrics"}      )    ),    "workload", "$1", "owner_name", "(.*)"  ))'
        labels: {
          workload_type: 'deployment'
        }
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job="kube-state-metrics", owner_kind="DaemonSet"},    "workload", "$1", "owner_name", "(.*)"  ))'
        labels: {
          workload_type: 'daemonset'
        }
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job="kube-state-metrics", owner_kind="StatefulSet"},    "workload", "$1", "owner_name", "(.*)"  ))'
        labels: {
          workload_type: 'statefulset'
        }
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job="kube-state-metrics", owner_kind="Job"},    "workload", "$1", "owner_name", "(.*)"  ))'
        labels: {
          workload_type: 'job'
        }
      }
      {
        record: ':node_memory_MemAvailable_bytes:sum'
        expression: 'sum(  node_memory_MemAvailable_bytes{job="node"} or  (    node_memory_Buffers_bytes{job="node"} +    node_memory_Cached_bytes{job="node"} +    node_memory_MemFree_bytes{job="node"} +    node_memory_Slab_bytes{job="node"}  )) by (cluster)'
      }
      {
        record: 'cluster:node_cpu:ratio_rate5m'
        expression: 'sum(rate(node_cpu_seconds_total{job="node",mode!="idle",mode!="iowait",mode!="steal"}[5m])) by (cluster) /count(sum(node_cpu_seconds_total{job="node"}) by (cluster, instance, cpu)) by (cluster)'
      }
    ]
  }
]
