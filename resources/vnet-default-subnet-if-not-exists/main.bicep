targetScope = 'resourceGroup'

param virtualNetworkName string
param addressPrefixes array = []
param virtualNetworkExists bool

param location string = resourceGroup().location

var defaultSubnets = [for addressPrefix in addressPrefixes: {
  name: 'default-${replace(addressPrefix, '/', '-')}'
  properties: {
    addressPrefix: addressPrefix
  }
}]

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' existing = if (virtualNetworkExists) {
  name: virtualNetworkName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: virtualNetworkExists ? existingVirtualNetwork.properties.subnets : defaultSubnets
  }
}


// module virtualNetwork 'vnet.bicep' = {
//   name: 'virtualNetwork'
//   params: {
//     location: location
//     virtualNetworkName: virtualNetworkName
//     addressPrefixes: virtualNetworkExists ? existingVirtualNetwork.properties.addressSpace.addressPrefixes : addressPrefixes 
//     subnets: virtualNetworkExists ? existingVirtualNetwork.properties.subnets : defaultSubnets
//   }
// }
