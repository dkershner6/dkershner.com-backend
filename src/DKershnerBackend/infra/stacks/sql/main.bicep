param servers_dk_sqlserver6_name string = 'dk-sqlserver6'

resource server 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: servers_dk_sqlserver6_name
  location: 'westus2'
  tags: {
    stack: 'dk-sql'
  }
  properties: {
    administratorLogin: 'CloudSA85bd9b0e'
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: 'dkershner@dkershner.com'
      sid: 'cd8c98e5-a072-4cd2-b738-cd66b0057235'
      tenantId: '5add7f53-d6f0-49f3-8a69-6789b632391c'
      azureADOnlyAuthentication: true
    }
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource serverAdmins 'Microsoft.Sql/servers/administrators@2023-08-01-preview' = {
  parent: server
  name: 'ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: 'dkershner@dkershner.com'
    sid: 'cd8c98e5-a072-4cd2-b738-cd66b0057235'
    tenantId: '5add7f53-d6f0-49f3-8a69-6789b632391c'
  }
}

resource createIndexAdvisor 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: server
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    server
  ]
}

resource dropIndexAdvisor 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: server
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    createIndexAdvisor
  ]
}

resource forceLastGoodPlanAdvisor 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: server
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
  dependsOn: [
    dropIndexAdvisor
  ]
}

resource azureAdOnlyAuth 'Microsoft.Sql/servers/azureADOnlyAuthentications@2023-08-01-preview' = {
  parent: server
  name: 'Default'
  properties: {
    azureADOnlyAuthentication: true
  }
}

resource serverConnectionPolicies 'Microsoft.Sql/servers/connectionPolicies@2023-08-01-preview' = {
  parent: server
  name: 'default'
  properties: {
    connectionType: 'Default'
  }
}

resource dkDatabase 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: server
  name: 'dk-sql'
  location: 'westus2'
  tags: {
    stack: 'dk-sql'
  }
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 34359738368
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    autoPauseDelay: 60
    requestedBackupStorageRedundancy: 'Local'
    minCapacity: json('0.5')
    maintenanceConfigurationId: '/subscriptions/892056f4-eec9-4029-a914-c885f318bf62/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default'
    isLedgerOn: false
    useFreeLimit: true
    freeLimitExhaustionBehavior: 'AutoPause'
    availabilityZone: 'NoPreference'
  }
}
