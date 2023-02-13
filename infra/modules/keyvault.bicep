param location string = 'eastus2'
param KeyvaultName string = 'keyvault-${uniqueString(resourceGroup().id)}'
param App_Service_Identity string
@secure()
param CognitiveServiceAccountKey1 string
param PrivateEndpointSubnet string 
param PrivateDNSZone string 

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
            'get'
            'set'
          ]
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Deny'
    }
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

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: '${KeyvaultName}-pe'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${KeyvaultName}-pe'
        properties: {
          privateLinkServiceId: keyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    customNetworkInterfaceName: '${KeyvaultName}-pe'
    subnet: {
      id: PrivateEndpointSubnet
    }
  }
}

resource PrivateEndpointDNSZone 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-07-01' = {
  name: '${KeyvaultName}-zone'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${KeyvaultName}-zone'
        properties: {
          privateDnsZoneId: PrivateDNSZone
        }
      }
    ]
  }
}

output keyvaultResourceId string = keyVault.id
