param vnetName string = 'securebackend-vnet'
param subnet1Name string = 'vnetintegrationsubnet'
param subnet2Name string = 'private-endpoint-subnet'
param location string 


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
 }
}


resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: subnet1Name
  parent: virtualNetwork
  properties: {
    addressPrefix: '10.0.0.0/24'
  delegations: [
      {
      name: 'Microsoft.Web/serverfarms'
      properties: {
      serviceName: 'Microsoft.Web/serverfarms'
        }
      }
    ]
  }
}

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: subnet2Name
  parent: virtualNetwork
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}


output vnetResourceID string = virtualNetwork.id 
