param env string
param synapsePrincipalId string
param location string
param subnetId string

var keyvaultName = 'BurkeKeyvault${env}'
var tenantId = subscription().tenantId

resource warehouseKeyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: [
        {
          id: subnetId
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
    enableSoftDelete: false
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: synapsePrincipalId
        permissions: {
          secrets:[
            'Get'
            'List'
          ]
        }
      }
    ]
    publicNetworkAccess: 'Enabled'
  }
}
