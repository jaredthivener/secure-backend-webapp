param location string = 'eastus2'
param KeyvaultName string = 'keyvault-${uniqueString(resourceGroup().id)}'
param App_Service_Identity string

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: KeyvaultName
  location: location
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: false
    enableRbacAuthorization: true
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
            'update'
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

output keyvaultResourceId string = keyVault.id
