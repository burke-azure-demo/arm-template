param env string
param location string = resourceGroup().location
param storageSKU string = 'Standard_LRS'

var name = 'burkewarehouse${toLower(env)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: name
  location: location
  sku: {
    name: storageSKU
  }
  tags: {
    displayName: name
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output endpoint string = storageAccount.properties.primaryEndpoints.dfs
output resourceId string = storageAccount.id
