targetScope = 'subscription'

param location string = 'eastus2'
param rgName string = 'rg-securebackend-webapp'


//Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
}

//vnet module
module vnet 'modules/networking.bicep' = {
  scope: resourceGroup
  name: 'virtual-network'
  params: {
    location: location
  }
}

//Keyvault module
module keyvault 'modules/keyvault.bicep' = {
  scope: resourceGroup
  name: 'keyvault'
  params: {
    App_Service_Identity: appService.outputs.appServiceAppIdentity
    CognitiveServiceAccountKey1: cognitive.outputs.csAccountKeys
    location: location
    PrivateEndpointSubnet: vnet.outputs.PrivateEndpointSubnetId
    PrivateDNSZone: vnet.outputs.keyvaultDnsZone
  }
  dependsOn: [
    [
      appService
    ]
  ]
}

//AppService module 
module appService 'modules/app-service.bicep' = {
  scope: resourceGroup
  name: 'app-services'
  params: {
    location: location
    virtualNetworkSubnetId: vnet.outputs.integrationSubnetId
  }
  dependsOn: [
    [
      vnet
    ]
  ]
}

//Cognitive Services module
module cognitive 'modules/cognitive.bicep' = {
  scope: resourceGroup
  name: 'cognitive-services'
  params: {
    location: location
    PrivateEndpointSubnet: vnet.outputs.PrivateEndpointSubnetId
    PrivateDNSZone: vnet.outputs.csDnsZone
  }
  dependsOn: [
    [
      appService
    ]
  ]
}
