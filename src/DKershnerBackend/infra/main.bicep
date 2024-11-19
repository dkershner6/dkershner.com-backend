targetScope = 'subscription'

resource sqlResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'dk-sql'
  location: 'westus2'
}

module sqlServer './sqlServer.bicep' = {
  name: 'sqlServer'
  scope: sqlResourceGroup
  params: {
    sqlServerName: null
  }
}

module sqlDatabase 'sqlDatabase.bicep' = {
  name: 'sqlDatabase'
  scope: sqlResourceGroup
  params: {
    sqlServerName: sqlServer.outputs.sqlServerName
  }
}
