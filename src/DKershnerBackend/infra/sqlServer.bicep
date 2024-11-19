param location string
param sqlServerName string = 'dk-sqlserver6'
param stackName string

resource server 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sqlServerName
  location: location
  tags: {
    stack: stackName
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
    #disable-next-line no-unnecessary-dependson // It is necessary
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

output sqlServerName string = server.name
