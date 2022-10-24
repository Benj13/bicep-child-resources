targetScope = 'resourceGroup'

param virtualNetworkName string
param addressPrefixes array = []
param virtualNetworkExists bool

param location string = resourceGroup().location

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' existing = if (virtualNetworkExists) {
  name: virtualNetworkName
}

var defaultSubnets = [for addressPrefix in addressPrefixes: {
  name: 'default-${replace(addressPrefix, '/', '-')}'
  properties: {
    addressPrefix: addressPrefix
  }
}]

module virtualNetwork 'vnet.bicep' = {
  name: 'virtualNetwork'
  params: {
    location: location
    virtualNetworkName: virtualNetworkName
    addressPrefixes: virtualNetworkExists ? existingVirtualNetwork.properties.subnets : defaultSubnets
  }
}
