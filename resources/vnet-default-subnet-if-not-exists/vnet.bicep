param virtualNetworkName string
param addressPrefixes array
param location string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for addressPrefix in addressPrefixes: {
      name: 'default-${replace(addressPrefix, '/', '-')}'
      properties: {
        addressPrefix: addressPrefix
      }
    }]
  }
}
