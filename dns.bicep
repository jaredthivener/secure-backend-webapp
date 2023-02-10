param location string = 'global'
param privateDNSzone1Name string = 'privatelink.cognitiveservices.azure.com'
param privateDNSzone2Name string = 'privatelink.vaultcore.azure.net'
param vnetResourceId string 


resource privateDNSzone1 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSzone1Name
  location: location
}

resource privateDNSzone2 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSzone2Name
  location: location
}


resource DNSlink1 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'cognitives-service'
  parent: privateDNSzone1
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetResourceId 
    }
  }
}

resource DNSlink2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'keyVault'
  parent: privateDNSzone2
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetResourceId
    }
  }
}
