param azureMonitorWorkspace object

resource AzureMonitorWorkspace 'microsoft.monitor/accounts@2021-06-03-preview' = {
  name: azureMonitorWorkspace.name
  location: azureMonitorWorkspace.region
}

output id string = AzureMonitorWorkspace.id
