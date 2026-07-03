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
      domain          = "pool1-app"
      # certificate_arn solo se necesita si se usa un dominio personalizado

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

      # Pre Token Generation V2_0 - Personalización de access token
      # Requiere plan Essentials o Plus en el User Pool
      # pre_token_generation_config = {
      #   lambda_arn     = "arn:aws:lambda:us-east-1:123456789012:function:pre-token-gen"
      #   lambda_version = "V2_0"  # V1_0 = solo ID token, V2_0 = ID + access token, V3_0 = ID + access + M2M
      # }
    }
  }
}