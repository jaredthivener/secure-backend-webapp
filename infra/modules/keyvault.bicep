param location string = 'eastus2'
param KeyvaultName string = 'keyvault-${uniqueString(resourceGroup().id)}'
param App_Service_Identity string
@secure()
param CognitiveServiceAccountKey1 string

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: KeyvaultName
  location: location
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: false
    enableRbacAuthorization: false
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: App_Service_Identity //Azure App Service
        permissions: {
          secrets: [
            'list'
            'create'
            'get'
            'set'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'CognitiveServiceAccountKey1'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
    }
    value: CognitiveServiceAccountKey1
  }
}


output keyvaultResourceId string = keyVault.id
