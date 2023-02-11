param location string = 'eastus2'

@description('The name of the App Service app. This name must be globally unique.')
param appServiceAppName string = 'app${uniqueString(resourceGroup().id)}'

var appServicePlanName = 'app${uniqueString(resourceGroup().id)}'
var appServicePlanSkuName = 'S1'

param virtualNetworkSubnetId string 

//Create App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  
  sku: {
    name: appServicePlanSkuName
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
    vnetRouteAllEnabled: true
  }
}

//Output App Service Web App Managed Identity Principal Id
output appServiceAppIdentity string = appServiceApp.identity.principalId
