resource "aws_cognito_user_pool" "pool" {
  provider = aws.project
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

  dynamic "lambda_config" {
    for_each = each.value.lambda_config != null ? [each.value.lambda_config] : []
    content {
      pre_sign_up                    = lambda_config.value.pre_sign_up
      post_confirmation              = lambda_config.value.post_confirmation
      pre_authentication             = lambda_config.value.pre_authentication
      post_authentication            = lambda_config.value.post_authentication
      custom_message                 = lambda_config.value.custom_message
      define_auth_challenge          = lambda_config.value.define_auth_challenge
      create_auth_challenge          = lambda_config.value.create_auth_challenge
      verify_auth_challenge_response = lambda_config.value.verify_auth_challenge_response
      pre_token_generation           = lambda_config.value.pre_token_generation
      user_migration                 = lambda_config.value.user_migration
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  provider = aws.project
  for_each = local.user_pool_clients_map

  name            = each.value.name
  user_pool_id    = each.value.user_pool_id
  generate_secret = each.value.generate_secret

  allowed_oauth_flows  = each.value.allowed_oauth_flows
  allowed_oauth_scopes = each.value.allowed_oauth_scopes
  callback_urls        = each.value.callback_urls
  logout_urls          = each.value.logout_urls

  supported_identity_providers         = each.value.supported_identity_providers
  explicit_auth_flows                  = each.value.explicit_auth_flows
  allowed_oauth_flows_user_pool_client = each.value.allowed_oauth_flows_user_pool_client

  prevent_user_existence_errors = each.value.prevent_user_existence_errors
  enable_token_revocation       = each.value.enable_token_revocation
  auth_session_validity         = each.value.auth_session_validity

  access_token_validity  = each.value.access_token_validity
  id_token_validity      = each.value.id_token_validity
  refresh_token_validity = each.value.refresh_token_validity

  token_validity_units {
    access_token  = each.value.token_validity_units.access_token
    id_token      = each.value.token_validity_units.id_token
    refresh_token = each.value.token_validity_units.refresh_token
  }

  depends_on = [aws_cognito_identity_provider.identity]
}

resource "aws_cognito_user_pool_domain" "domain" {
  provider = aws.project
  for_each = var.user_pools

  domain          = each.value.domain
  user_pool_id    = aws_cognito_user_pool.pool[each.key].id
  certificate_arn = each.value.certificate_arn # null cuando se usa el dominio predeterminado de Cognito
}

resource "aws_cognito_identity_provider" "identity" {
  provider = aws.project
  for_each = local.identity_providers_map

  provider_name     = each.value.provider_name
  user_pool_id      = each.value.user_pool_id
  provider_type     = each.value.provider_type
  attribute_mapping = each.value.attribute_mapping
  provider_details = each.value.provider_details
}

resource "aws_cognito_resource_server" "resource_server" {
  provider = aws.project
  for_each = local.resource_servers_map

  identifier   = each.value.identifier
  name         = each.value.name
  user_pool_id = each.value.user_pool_id

  dynamic "scope" {
    for_each = each.value.scopes
    content {
      scope_name        = scope.value.scope_name
      scope_description = scope.value.scope_description
    }
  }
}