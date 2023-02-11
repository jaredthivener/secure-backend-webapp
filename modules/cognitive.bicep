param location string = 'centralus'
param cgsSKU string = 'F0'
param cgsKind string = 'TextAnalytics'
param cgsName string = 'cs-${uniqueString(resourceGroup().id)}'

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2022-10-01' = {
  name: cgsName
  location: location
  kind: cgsKind
  sku: {
    name: cgsSKU
  }
}

output cognitiveResourceId string = cognitiveService.id
