param location string
param stackName string

param hostingPlanId string

param name string = 'dk-webapp'
var alwaysOn = false
var ftpsState = 'FtpsOnly'
var autoGeneratedDomainNameLabelScope = 'TenantReuse'

var currentStack = 'dotnet'
var phpVersion = 'OFF'
var netFrameworkVersion = 'v8.0'

resource insightsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: 'DefaultWorkspace-892056f4-eec9-4029-a914-c885f318bf62-WUS2'
  location: 'westus2'
  properties: {}
}

resource insights 'microsoft.insights/components@2020-02-02-preview' = {
  name: '${name}-insights'
  location: 'westus2'
  tags: {
    stack: 'dk-webapp'
  }
  properties: {
    ApplicationId: name
    Request_Source: 'IbizaWebAppExtensionCreate'
    Flow_Type: 'Redfield'
    Application_Type: 'web'
    WorkspaceResourceId: insightsWorkspace.id
  }
  dependsOn: [
    insightsWorkspace
  ]
}

resource name_resource 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  tags: {
    stack: stackName
  }
  properties: {
    name: name
    siteConfig: {
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: insights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'default'
        }
      ]
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: currentStack
        }
      ]
      phpVersion: phpVersion
      netFrameworkVersion: netFrameworkVersion
      alwaysOn: alwaysOn
      ftpsState: ftpsState
    }
    serverFarmId: hostingPlanId
    clientAffinityEnabled: true
    virtualNetworkSubnetId: null
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    autoGeneratedDomainNameLabelScope: autoGeneratedDomainNameLabelScope
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    insights
  ]
}

resource name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: name_resource
  name: 'scm'
  properties: {
    allow: false
  }
}

resource name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: name_resource
  name: 'ftp'
  properties: {
    allow: false
  }
}
