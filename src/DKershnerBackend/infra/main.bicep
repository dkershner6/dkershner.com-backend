targetScope = 'subscription'

param location string = 'westus2'
param stackName string = 'dk-test-webapp'

resource sqlResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'dk-sql'
  location: location
}

module sqlServer './sqlServer.bicep' = {
  name: 'sqlServer'
  scope: sqlResourceGroup
  params: {
    location: location
    stackName: stackName
  }
}

module sqlDatabase 'sqlDatabase.bicep' = {
  name: 'sqlDatabase'
  scope: sqlResourceGroup
  params: {
    location: location
    sqlServerName: sqlServer.outputs.sqlServerName
    stackName: stackName
  }
  dependsOn: [
    sqlServer
  ]
}

resource webappResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'dk-webapp'
  location: location
}

module hostingPlan './webServerFarm.bicep' = {
  name: 'hostingPlan'
  scope: webappResourceGroup
  params: {
    location: location
    stackName: stackName
  }
}

module webApp 'webApp.bicep' = {
  name: 'webApp'
  scope: webappResourceGroup
  params: {
    location: location
    stackName: stackName
    hostingPlanId: hostingPlan.outputs.hostingPlanId
  }
  dependsOn: [
    hostingPlan
  ]
}
