param env string
param synapsePrincipalId string
param location string
param subnetId string
param serviceConnectionClientId string
param serviceConnectionAppObjectId string

var keyvaultName = 'Burke2Keyvault${env}'
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
    enableSoftDelete: true
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
      {
        tenantId: serviceConnectionClientId
        objectId: serviceConnectionAppObjectId
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '0.0.0.0/0'
        }
      ]
      virtualNetworkRules: [
        {
          id: subnetId
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
    publicNetworkAccess: 'Enabled'
  }
}
