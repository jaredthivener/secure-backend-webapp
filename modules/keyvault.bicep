param location string = 'centralus'
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
        objectId: App_Service_Identity //Microsoft Azure App Service
        permissions: {
          secrets: [
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

resource privateEndpoint_00 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: 'keyvault'
  location: location
  properties: {
    subnet: {
      id: subnet2.id
    }
    privateLinkServiceConnections: [
      {
        id: keyVault.id
      }
    ]
  }
}

output keyvaultResourceId string = keyVault.id
