param location string = 'eastus2'
param cgsSKU string = 'F0'
param cgsKind string = 'TextAnalytics'
param cgsName string = 'cs-${uniqueString(resourceGroup().id)}'
param PrivateEndpointSubnet string

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2022-10-01' = {
  name: cgsName
  location: location
  kind: cgsKind
  properties: {
    customSubDomainName: cgsName
  }
  sku: {
    name: cgsSKU
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: '${cgsName}-pe'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${cgsName}-pe'
        properties: {
          privateLinkServiceId: cognitiveService.id
          groupIds: [
            'account'
          ]
        }
      }
    ]
    customNetworkInterfaceName: '${cgsName}-pe'
    subnet: {
      id: PrivateEndpointSubnet
    }
  }
}

output csAccountKeys string = cognitiveService.listKeys().key1
output cognitiveResourceId string = cognitiveService.id
