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

  dynamic "admin_create_user_config" {
    for_each = each.value.admin_create_user_config != null ? [each.value.admin_create_user_config] : []
    content {
      allow_admin_create_user_only = admin_create_user_config.value.allow_admin_create_user_only
    }
  }
  dynamic "user_attribute_update_settings" {
    for_each = each.value.user_attribute_update_settings != null ? [each.value.user_attribute_update_settings] : []
    content {
      attributes_require_verification_before_update = user_attribute_update_settings.value.attributes_require_verification_before_update
    }
  }
  dynamic "lambda_config" {
    for_each = (each.value.lambda_config != null || each.value.pre_token_generation_config != null) ? [true] : []
    content {
      pre_sign_up                    = try(each.value.lambda_config.pre_sign_up, null)
      post_confirmation              = try(each.value.lambda_config.post_confirmation, null)
      pre_authentication             = try(each.value.lambda_config.pre_authentication, null)
      post_authentication            = try(each.value.lambda_config.post_authentication, null)
      custom_message                 = try(each.value.lambda_config.custom_message, null)
      define_auth_challenge          = try(each.value.lambda_config.define_auth_challenge, null)
      create_auth_challenge          = try(each.value.lambda_config.create_auth_challenge, null)
      verify_auth_challenge_response = try(each.value.lambda_config.verify_auth_challenge_response, null)
      pre_token_generation           = try(each.value.lambda_config.pre_token_generation, null)
      user_migration                 = try(each.value.lambda_config.user_migration, null)

      dynamic "pre_token_generation_config" {
        for_each = each.value.pre_token_generation_config != null ? [each.value.pre_token_generation_config] : []
        content {
          lambda_arn     = pre_token_generation_config.value.lambda_arn
          lambda_version = pre_token_generation_config.value.lambda_version
        }
      }
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
  provider_details  = each.value.provider_details
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