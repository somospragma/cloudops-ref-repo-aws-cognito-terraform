#Variables cognito

variable "user_pools" {
  description = "Mapa de configuraciones para cada Cognito User Pool, con clientes, dominio y (opcionalmente) proveedores de identidad"
  type = map(object({
    name                     = string
    alias_attributes         = list(string)
    auto_verified_attributes = list(string)
    password_policy = object({
      minimum_length    = number
      require_lowercase = bool
      require_numbers   = bool
      require_symbols   = bool
      require_uppercase = bool
    })
    domain          = string                    # Dominio para el User Pool (único por pool)
    certificate_arn = optional(string, null)    # ARN del certificado (si se usa dominio personalizado; null para dominio predeterminado)
    clients = map(object({
      name                 = string
      generate_secret      = bool
      allowed_oauth_flows  = list(string)
      allowed_oauth_scopes = list(string)
      callback_urls        = list(string)
      logout_urls          = list(string)
      supported_identity_providers         = optional(list(string), ["COGNITO"])
      explicit_auth_flows                  = optional(list(string), [])
      allowed_oauth_flows_user_pool_client = optional(bool, true)
      prevent_user_existence_errors        = optional(string, "ENABLED")
      enable_token_revocation              = optional(bool, true)
      auth_session_validity                = optional(number, 3)
      access_token_validity                = optional(number, 60)
      id_token_validity                    = optional(number, 60)
      refresh_token_validity               = optional(number, 30)
      token_validity_units = optional(object({
        access_token  = optional(string, "minutes")
        id_token      = optional(string, "minutes")
        refresh_token = optional(string, "days")
      }), {})
    }))
    federated_identity_providers = optional(map(object({
      provider_type    = string  # "Google", "Facebook", etc.
      provider_name    = string  # Nombre que se usará en Cognito (por ejemplo, "Google")
      client_id        = string
      client_secret    = string
      authorize_scopes = string  # Ejemplo: "email profile"
      attribute_mapping = map(string)
    })), {})  # Valor por defecto: mapa vacío
    resource_servers = optional(map(object({
      identifier = string
      name       = string
      scopes = optional(map(object({
        scope_name        = string
        scope_description = string
      })), {})
    })), {})
    lambda_config = optional(object({
      pre_sign_up                    = optional(string, null) # ARN de Lambda para pre-registro
      post_confirmation              = optional(string, null) # ARN de Lambda post-confirmación
      pre_authentication             = optional(string, null) # ARN de Lambda pre-autenticación
      post_authentication            = optional(string, null) # ARN de Lambda post-autenticación
      custom_message                 = optional(string, null) # ARN de Lambda para mensajes personalizados
      define_auth_challenge          = optional(string, null) # ARN de Lambda para definir reto de auth
      create_auth_challenge          = optional(string, null) # ARN de Lambda para crear reto de auth
      verify_auth_challenge_response = optional(string, null) # ARN de Lambda para verificar respuesta de reto
      pre_token_generation           = optional(string, null) # ARN de Lambda pre-generación de token
      user_migration                 = optional(string, null) # ARN de Lambda para migración de usuarios
    }), null)
  }))
  default = {}
}