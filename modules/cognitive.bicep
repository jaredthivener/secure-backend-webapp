param location string = 'centralus'
param cgsSKU string = 'F0'
param cgsKind string = 'TextAnalytics'
param cgsName string = 'securecstext2023'

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2022-10-01' = {
  name: cgsName
  location: location
  kind: cgsKind
  sku: {
    name: cgsSKU
  }
}

resource privateEndpoint_01 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: 'cognitiveService'
  location: location
  properties: {
    subnet: {
      id: subnet2.id
    }
    privateLinkServiceConnections: [
      {
        id: cognitiveServiceId
      }
    ]
  }
  dependsOn: [
    virtualNetwork
  ]
}

output cognitiveResourceId string = cognitiveService.id
