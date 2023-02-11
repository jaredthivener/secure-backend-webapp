param location string = 'eastus2'
param vnetName string = 'vnet-${uniqueString(resourceGroup().id)}'
param subnet1Name string = 'vnet-integration-subnet'
param subnet2Name string = 'private-endpoint-subnet'
param privateDNSzone1Name string = 'privatelink.cognitiveservices.azure.com'
param privateDNSzone2Name string = 'privatelink.vaultcore.azure.net' 

//Create Virtual Network 
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

//Create App Service - Integration Subnet w/delegation 
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
  dependsOn: [
    [
      virtualNetwork
    ]
  ]
}

//Create Private Endpoint Subnet
resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: subnet2Name
  parent: virtualNetwork
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
  dependsOn: [
    [
      virtualNetwork
    ]
  ]
}

//Create Cognitive Services DNS Namespace
resource privateDNSzone1 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSzone1Name
  location: 'global'
}

//Link Cognitive Services DNS Namespace to Virtual Network
resource DNSlink1 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'cognitives-service'
  parent: privateDNSzone1
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id 
    }
  }
}

//Create Keyvault DNS Namespace
resource privateDNSzone2 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSzone2Name
  location: 'global'
}

//Link Keyvault DNS Namespace to Virtual Network
resource DNSlink2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'keyVault'
  parent: privateDNSzone2
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}


output vnetResourceId string = virtualNetwork.id 
output integrationSubnetId string = subnet1.id
output PrivateEndpointSubnetId string = subnet2.id
