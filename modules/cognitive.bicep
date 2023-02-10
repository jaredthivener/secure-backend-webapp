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

output cognitiveResourceId string = cognitiveService.id
