param location string = 'centralus'

@description('The type of environment. This must be dev or prod.')
@allowed([
  'dev'
  'prod'
])
param environmentType string

@description('The name of the App Service app. This name must be globally unique.')
param appServiceAppName string = 'app${uniqueString(resourceGroup().id)}'

var appServicePlanName = 'app${uniqueString(resourceGroup().id)}'
var appServicePlanSkuName = (environmentType == 'dev') ?  'F1' : 'P2v3'
var appServicePlanTierName = (environmentType == 'dev') ? 'Free' : 'PremiumV3' 

param virtualNetworkSubnetId string 

//Create App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }
}

//Create App Service Web App
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

//Output App Service Web App Managed Identity Principal Id
output appServiceAppIdentity string = appServiceApp.identity.principalId
