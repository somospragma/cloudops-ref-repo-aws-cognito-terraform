resource "aws_cognito_user_pool" "pool" {
  for_each = var.user_pools

  name                     = each.value.name
  alias_attributes         = each.value.alias_attributes
  auto_verified_attributes = each.value.auto_verified_attributes

  password_policy {
    minimum_length    = each.value.password_policy.minimum_length
    require_lowercase = each.value.password_policy.require_lowercase
    require_numbers   = each.value.password_policy.require_numbers
    require_symbols   = each.value.password_policy.require_symbols
    require_uppercase = each.value.password_policy.require_uppercase
  }
}

resource "aws_cognito_user_pool_client" "client" {
  for_each = local.user_pool_clients_map

  name          = each.value.name
  user_pool_id  = each.value.user_pool_id
  generate_secret = each.value.generate_secret

  allowed_oauth_flows  = each.value.allowed_oauth_flows
  allowed_oauth_scopes = each.value.allowed_oauth_scopes
  callback_urls        = each.value.callback_urls
  logout_urls          = each.value.logout_urls

  supported_identity_providers = each.value.supported_identity_providers

}

resource "aws_cognito_user_pool_domain" "domain" {
  for_each = var.user_pools
  domain       = each.value.domain
  user_pool_id = aws_cognito_user_pool.pool[each.key].id
  # Si se usa un dominio personalizado, se requiere el ARN del certificado ACM
  certificate_arn = each.value.certificate_arn
}

resource "aws_cognito_identity_provider" "identity" {
  for_each = local.identity_providers_map

  provider_name     = each.value.provider_name
  user_pool_id      = each.value.user_pool_id
  provider_type     = each.value.provider_type
  attribute_mapping = each.value.attribute_mapping
  provider_details = each.value.provider_details
}