param location string
param stackName string

param hostingPlanName string = 'dk-serverfarm'
param sku string = 'Free'
param skuCode string = 'F1'
param workerSize string = '0'
param workerSizeId string = '0'
param numberOfWorkers string = '1'

resource hostingPlan 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: hostingPlanName
  location: location
  kind: ''
  tags: {
    stack: stackName
  }
  properties: {
    name: hostingPlanName
    workerSize: workerSize
    workerSizeId: workerSizeId
    numberOfWorkers: numberOfWorkers
    zoneRedundant: false
  }
  sku: {
    tier: sku
    name: skuCode
  }
  dependsOn: []
}

output hostingPlanId string = hostingPlan.id
