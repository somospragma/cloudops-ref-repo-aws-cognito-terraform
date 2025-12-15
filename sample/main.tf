module "cognito" {
  source = "./module/cognito"

  user_pools = {
    pool1 = {
      name                     = "${var.client}-${var.project}-${var.environment}-${var.application}-${var.functionality}-1"
      alias_attributes         = ["email"]
      auto_verified_attributes = ["email"]
      password_policy = {
        minimum_length    = 10
        require_lowercase = true
        require_numbers   = true
        require_symbols   = false
        require_uppercase = true
      }
      domain                           = "pool1-app"
      certificate_arn                  = ""  # Opcional, solo si se usa dominio personalizado

      # Proveedores federados (opcional). Si no se definen, no se crean.
      # federated_identity_providers = {
      #   google = {
      #     provider_type    = "Google"
      #     provider_name    = "Google"
      #     client_id        = "TU_GOOGLE_CLIENT_ID"
      #     client_secret    = "TU_GOOGLE_CLIENT_SECRET"
      #     authorize_scopes = "email profile"
      #     attribute_mapping = {
      #       email    = "email"
      #       username = "sub"
      #     }
      #   }
      #   facebook = {
      #     provider_type    = "Facebook"
      #     provider_name    = "Facebook"
      #     client_id        = "TU_FACEBOOK_CLIENT_ID"
      #     client_secret    = "TU_FACEBOOK_CLIENT_SECRET"
      #     authorize_scopes = "email public_profile"
      #     attribute_mapping = {
      #       email    = "email"
      #       username = "id"
      #     }
      #   }
      # }
      
      clients = {
        clientA = {
          name                 = "cliente-web"
          generate_secret      = true
          allowed_oauth_flows  = ["implicit"]
          allowed_oauth_scopes = ["email", "openid"]
          callback_urls        = ["https://app.com/callback"]
          logout_urls          = ["https://app.com/logout"]
          # supported_identity_providers = ["Google", "Facebook"] # Si se requiere el uso de la identidad federada
        }
        clientB = {
          name                 = "cliente-mobile"
          generate_secret      = false
          allowed_oauth_flows  = ["code"]
          allowed_oauth_scopes = ["openid", "profile"]
          callback_urls        = ["app://callback"]
          logout_urls          = []
        }
      }
    }
    pool2 = {
      name                     = "${var.client}-${var.project}-${var.environment}-${var.application}-${var.functionality}-2"
      alias_attributes         = ["email", "phone_number"]
      auto_verified_attributes = ["email"]
      password_policy = {
        minimum_length    = 8
        require_lowercase = true
        require_numbers   = true
        require_symbols   = true
        require_uppercase = true
      }
      domain          = "pool2-app"
      certificate_arn = ""
      clients = {
        clientC = {
          name                 = "cliente-admin"
          generate_secret      = true
          allowed_oauth_flows  = ["implicit"]
          allowed_oauth_scopes = ["email", "openid", "aws.cognito.signin.user.admin"]
          callback_urls        = ["https://admin.app.com/callback"]
          logout_urls          = ["https://admin.app.com/logout"]
        }
      }
    }
  }
}