targetScope = 'subscription'

param location string = 'centralus'
param rgName string = 'rg-securebackendsetup'
param tags object = {
  Environement: 'dev'
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
module vnet 'vnet.bicep' = {
  scope: resourceGroup
  name: 'virtual-network'
  params: {
    location: location
  }
}

//DNS module 
module dns 'dns.bicep' = {
  scope: resourceGroup
  name: 'dns'
  params: {
    vnetResourceId: vnet.outputs.vnetResourceID
    location: 'global'
  }
}
