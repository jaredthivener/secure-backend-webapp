targetScope = 'subscription'

param location string = 'centralus'
param rgName string = 'rg-securebackendsetup'
param tags object = {
  Environement: 'Dev'
  Administrator: 'Alina'
  Team: 'Slalom'
}

//Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: tags
}

//vnet module
module vnet 'modules/networking.bicep' = {
  scope: resourceGroup
  name: 'virtual-network'
  params: {
    location: location
    keyvaultId: keyvault.outputs.keyvaultResourceId
    cognitiveServiceId: cognitive.outputs.cognitiveResourceId
  }
}


//Keyvault module
module keyvault 'modules/keyvault.bicep' = {
  scope: resourceGroup
  name: 'keyvault'
  params: {
    App_Service_Identity: appService.outputs.appServiceAppIdentity
    location: location
  }
}

//AppService module 
module appService 'modules/app-service.bicep' = {
  scope: resourceGroup
  name: 'app-service'
  params: {
    environmentType: 'dev'
    location: location
    virtualNetworkSubnetId: vnet.outputs.vnetResourceId
  }
}

//Cognitive module
module cognitive 'modules/cognitive.bicep' = {
  scope: resourceGroup
  name: 'cognitive'
  params: {
    location: location
  }
}
