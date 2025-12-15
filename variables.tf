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
    domain         = string             # Dominio para el User Pool (único por pool)
    certificate_arn = string            # ARN del certificado (si se usa dominio personalizado; puede dejarse vacío)
    clients = map(object({
      name                 = string
      generate_secret      = bool
      allowed_oauth_flows  = list(string)
      allowed_oauth_scopes = list(string)
      callback_urls        = list(string)
      logout_urls          = list(string)
      supported_identity_providers = optional(list(string), [])
      explicit_auth_flows  = optional(list(string), [])
      allowed_oauth_flows_user_pool_client = optional(bool, false)
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
  }))
  default = {}
}