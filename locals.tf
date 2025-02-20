locals {
  user_pool_clients = flatten([
    for pool_key, pool in var.user_pools : [
      for client_key, client in pool.clients : {
        id            = "${pool_key}_${client_key}"
        user_pool_id  = aws_cognito_user_pool.pool[pool_key].id
        name          = client.name
        generate_secret      = client.generate_secret
        allowed_oauth_flows  = client.allowed_oauth_flows
        allowed_oauth_scopes = client.allowed_oauth_scopes
        callback_urls        = client.callback_urls
        logout_urls          = client.logout_urls
        supported_identity_providers = client.supported_identity_providers
      }
    ]
  ])

  user_pool_clients_map = { for client in local.user_pool_clients : client.id => client }

  user_pool_identity_providers = flatten([
    for pool_key, pool in var.user_pools : [
      for idp_key, idp in lookup(pool, "federated_identity_providers", {}) : {
        id            = "${pool_key}_${idp_key}"
        user_pool_id  = aws_cognito_user_pool.pool[pool_key].id
        provider_name = idp.provider_name
        provider_type = idp.provider_type
        attribute_mapping = idp.attribute_mapping
        provider_details = {
          client_id        = idp.client_id
          client_secret    = idp.client_secret
          authorize_scopes = idp.authorize_scopes
        }
      }
    ]
  ])

  identity_providers_map = { for idp in local.user_pool_identity_providers : idp.id => idp }
}
