# Kubernetes Modules

## Kubernetes Base System

### cloud-node-manager

- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

### coredns

- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

### coredns-autoscaler

- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

### kube-proxy

- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

### metrics-server

- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

### konnectivity-agent

- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

## Azure Section

### retina-agent

- Developer: Microsoft
- Namespace: kube-system
- Notes: This gets installed when you install Azures version of Prometheus in k8s.
- Repositories: [Github](https://github.com/microsoft/retina)
- Documentations: None
- Description: A cloud-agnostic, open-source Kubernetes network observability platform that provides a centralized hub for monitoring application health, network health, and security

### ama-metrics

- Developer: Microsoft
- Namespace: kube-system
- Notes: This gets installed when you install Azures version of Prometheus in k8s.
- Repository:
- Documentations
- [Azure Monitor Agent overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)
- [Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview)
- [Prometheus Metrics Scrape Configuration](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/prometheus-metrics-scrape-configuration)
- [Prometheus Metrics Troubleshoot](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/prometheus-metrics-troubleshoot)
- Description: The Azure Monitor Agent(AMA) is one method of data collection for Azure Monitor. It's installed on virtual machines running in Azure, in other clouds, or on-premises where it has access to local logs and performance data. Without the agent, you could only collect data from the host machine since you would have no access to the client operating system and running processes.

### ama-metrics-operator-targets

- Developer: Microsoft
- Namespace: kube-system
- Notes: This gets installed when you install Azures version of Prometheus in k8s.
  - Bug: [Bug](https://github.com/Azure/AKS/issues/4509)
- Repository:
- Documentations:
- Description:

### azure-cns

- Developer: Microsoft
- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

### azure-ip-masq-agent

- Developer: Microsoft
- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description:

### csi-azuredisk-node

- Developer: Microsoft
- Namespace: kube-system
- Notes:
- Repository:
- Documentations:
- Description: