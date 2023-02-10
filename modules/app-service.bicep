param location string

@description('The type of environment. This must be dev or prod.')
@allowed([
  'dev'
  'prod'
])
param environmentType string

@description('The name of the App Service app. This name must be globally unique.')
param appServiceAppName string = 'app${uniqueString(resourceGroup().id)}'

var appServicePlanName = 'app${uniqueString(resourceGroup().id)}'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'
var appServicePlanTierName = (environmentType == 'prod') ? 'PremiumV3' : 'Free'

param virtualNetworkSubnetId string 

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    virtualNetworkSubnetId: virtualNetworkSubnetId
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceAppIdentity string = appServiceApp.identity.principalId
