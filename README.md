# **🚀 Módulo Terraform para Cognito: cloudops-ref-repo-aws-cognito-terraform**

## Descripción:

Este módulo de Terraform permite la creación de múltiples **Cognito User Pools** en AWS, incluyendo la configuración de dominios, clientes (app clients), proveedores de identidad federados (por ejemplo, Google y Facebook) y Lambda triggers de forma opcional. Con este módulo, podrás gestionar de forma centralizada la infraestructura de autenticación de tus aplicaciones.

---

## Características

- **Múltiples User Pools:** Permite crear varios pools de usuarios según las necesidades de tu aplicación.
- **Configuración de Dominio:** Asigna a cada pool su propio dominio (utilizando el dominio predeterminado de Cognito o uno personalizado mediante un certificado ACM).
- **Clientes Asociados:** Define múltiples clientes para cada pool, configurando flujos OAuth, scopes, URLs de callback y logout.
- **Public Clients:** Soporte nativo para clientes públicos (SPA, mobile) con defaults seguros: `prevent_user_existence_errors`, `enable_token_revocation` y `auth_session_validity`.
- **Proveedores Federados Opcionales:** Habilita la autenticación a través de proveedores externos (por ejemplo, Google y Facebook) de forma opcional.
- **Resource Servers:** Configura servidores de recursos con scopes personalizados para proteger APIs.
- **Lambda Triggers:** Configura funciones Lambda para personalizar el flujo de autenticación (pre-registro, post-confirmación, migración de usuarios, etc.).

---

Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo

El módulo cuenta con la siguiente estructura:

```bash
cloudops-ref-repo-aws-cognito-terraform/
└── sample/
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── terraform.auto.tfvars
    └── variables.tf
├── CHANGELOG.md
├── README.md
├── locals.tf
├── main.tf
├── outputs.tf
├── variables.tf
```

- Los archivos principales del módulo (`main.tf`, `outputs.tf`, `variables.tf`, `locals.tf`) se encuentran en el directorio raíz.
- `CHANGELOG.md` y `README.md` también están en el directorio raíz para fácil acceso.
- La carpeta `sample/` contiene un ejemplo de implementación del módulo.


## Uso del Módulo:

```hcl
module "cognito" {
  source = "./terraform-aws-cognito"

  user_pools = {
    pool1 = {
      name                     = "xxxx"
      alias_attributes         = ["xxxx"]
      auto_verified_attributes = ["xxxx"]
      password_policy = {
        minimum_length    = xx
        require_lowercase = true
        require_numbers   = true
        require_symbols   = false
        require_uppercase = true
      }
      domain = "xxxx"
      # certificate_arn solo se necesita si se usa un dominio personalizado
      # certificate_arn = "arn:aws:acm:us-east-1:123456789:certificate/xxxx"

      # Proveedores federados (opcional)
      federated_identity_providers = {
        google = {
          provider_type     = "Google"
          provider_name     = "Google"
          client_id         = "YOUR_GOOGLE_CLIENT_ID"
          client_secret     = "YOUR_GOOGLE_CLIENT_SECRET"
          authorize_scopes  = "email profile"
          attribute_mapping = {
            email    = "xxxx"
            username = "xxxx"
          }
        }
        facebook = {
          provider_type     = "Facebook"
          provider_name     = "Facebook"
          client_id         = "YOUR_FACEBOOK_CLIENT_ID"
          client_secret     = "YOUR_FACEBOOK_CLIENT_SECRET"
          authorize_scopes  = "email public_profile"
          attribute_mapping = {
            email    = "xxxx"
            username = "xxxx"
          }
        }
      }

      # Resource Servers (opcional)
      resource_servers = {
        api = {
          identifier = "my-api"
          name       = "My API"
          scopes = {
            read = {
              scope_name        = "read"
              scope_description = "Read access"
            }
            write = {
              scope_name        = "write"
              scope_description = "Write access"
            }
          }
        }
      }

      # Lambda Triggers (opcional)
      lambda_config = {
        pre_sign_up       = "arn:aws:lambda:us-east-1:123456789:function:pre-signup"
        post_confirmation = "arn:aws:lambda:us-east-1:123456789:function:post-confirm"
        custom_message    = "arn:aws:lambda:us-east-1:123456789:function:custom-msg"
      }

      # Configuración de clientes para este pool
      clients = {
        clienteWeb = {
          name                         = "xxxx"
          generate_secret              = true
          allowed_oauth_flows          = ["xxxx"]
          allowed_oauth_scopes         = ["xxxx"]
          callback_urls                = ["xxxx"]
          logout_urls                  = ["xxxx"]
          supported_identity_providers = ["Google", "Facebook", "COGNITO"]
          explicit_auth_flows          = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
          access_token_validity        = 60
          id_token_validity            = 60
          refresh_token_validity       = 30
          token_validity_units = {
            access_token  = "minutes"
            id_token      = "minutes"
            refresh_token = "days"
          }
        }
        clienteMobile = {
          name                 = "xxxx"
          generate_secret      = false
          allowed_oauth_flows  = ["code"]
          allowed_oauth_scopes = ["openid", "email", "profile"]
          callback_urls        = ["myapp://callback"]
          logout_urls          = ["myapp://logout"]
          explicit_auth_flows  = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
          # Los siguientes campos usan defaults seguros:
          # supported_identity_providers         = ["COGNITO"]
          # allowed_oauth_flows_user_pool_client = true
          # prevent_user_existence_errors        = "ENABLED"
          # enable_token_revocation              = true
          # auth_session_validity                = 3
        }
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.project"></a> [aws.project](#provider\_aws) | >= 4.31.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_cognito_identity_provider.identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider) | resource |
| [aws_cognito_resource_server.resource_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) | resource |

## 📌 Variables

### 🔹 Configuración General

| Nombre          | Tipo   | Descripción | Predeterminado | Obligatorio |
|-----------------|--------|-------------|----------------|-------------|
| `client`        | string | Nombre del cliente. | - | Sí |
| `environment`   | string | Entorno de despliegue (dev, staging, prod, etc.). | - | Sí |
| `project`       | string | Nombre del proyecto. | - | Sí |
| `functionality` | string | Funcionalidad específica dentro del proyecto. | - | Sí |
| `application`   | string | Nombre de la aplicación asociada al API Gateway. | - | Sí |
| `aws_region`    | string | Región de AWS donde se desplegará la infraestructura. | - | Sí |

### 🔹 Configuración de User_pool

**Tipo:** `map(object({ ... }))`  
**Descripción:**  
Contiene la configuración para cada Cognito User Pool. Cada entrada del mapa define un pool con sus propiedades, clientes, proveedores de identidad federados y Lambda triggers.

### Estructura de cada pool

```hcl
object({
  name                     = string         // Nombre del Cognito User Pool.
  alias_attributes         = list(string)   // Lista de atributos alias permitidos (ejemplo: ["email"]).
  auto_verified_attributes = list(string)   // Lista de atributos a verificar automáticamente (ejemplo: ["email"] o ["email", "phone_number"]).
  password_policy = object({                  // Configuración de la política de contraseñas.
    minimum_length    = number,               // Número mínimo de caracteres.
    require_lowercase = bool,                 // Se requiere al menos una letra minúscula.
    require_numbers   = bool,                 // Se requiere al menos un número.
    require_symbols   = bool,                 // Se requiere al menos un símbolo.
    require_uppercase = bool                  // Se requiere al menos una letra mayúscula.
  })
  domain          = string                   // Prefijo para el dominio del pool (por ejemplo, "pool1-miapp" se convierte en pool1-miapp.auth.<region>.amazoncognito.com).
  certificate_arn = optional(string, null)   // (Opcional) ARN del certificado ACM para dominios personalizados. Omitir o null para usar el dominio predeterminado.
  clients = map(object({                      // Configuración de los clientes (app clients) asociados al pool.
    name                         = string,    // Nombre del cliente.
    generate_secret              = bool,      // Indica si se debe generar un secret. false para public clients (SPA/mobile).
    allowed_oauth_flows          = list(string), // Flujos OAuth permitidos (ejemplo: ["implicit"] o ["code"]).
    allowed_oauth_scopes         = list(string), // Scopes permitidos (ejemplo: ["email", "openid"]).
    callback_urls                = list(string), // Lista de URLs de callback.
    logout_urls                  = list(string), // Lista de URLs de logout.
    supported_identity_providers         = optional(list(string), ["COGNITO"]) // (Opcional) Proveedores soportados. Default: ["COGNITO"].
    explicit_auth_flows                  = optional(list(string), []) // (Opcional) Flujos de autenticación explícitos.
    allowed_oauth_flows_user_pool_client = optional(bool, true)  // (Opcional) Habilita OAuth 2.0. Default: true.
    prevent_user_existence_errors        = optional(string, "ENABLED") // (Opcional) Evita enumeración de usuarios. Default: "ENABLED".
    enable_token_revocation              = optional(bool, true)   // (Opcional) Permite revocar refresh tokens. Default: true.
    auth_session_validity                = optional(number, 3)    // (Opcional) Duración de sesión auth en minutos (3-15). Default: 3.
    access_token_validity                = optional(number, 60)   // (Opcional) Validez del access token. Default: 60.
    id_token_validity                    = optional(number, 60)   // (Opcional) Validez del ID token. Default: 60.
    refresh_token_validity               = optional(number, 30)   // (Opcional) Validez del refresh token. Default: 30.
    token_validity_units = optional(object({   // (Opcional) Unidades de validez de tokens.
      access_token  = optional(string, "minutes")
      id_token      = optional(string, "minutes")
      refresh_token = optional(string, "days")
    }), {})
  }))
  federated_identity_providers = optional(map(object({  // (Opcional) Configuración de proveedores de identidad federados.
    provider_type     = string,            // Tipo de proveedor (ejemplo: "Google" o "Facebook").
    provider_name     = string,            // Nombre que se usará en Cognito (ejemplo: "Google").
    client_id         = string,            // Client ID obtenido al registrar la aplicación en el proveedor.
    client_secret     = string,            // Client Secret correspondiente.
    authorize_scopes  = string,            // Scopes autorizados (ejemplo: "email profile").
    attribute_mapping = map(string)        // Mapeo de atributos entre el proveedor y Cognito.
  })), {})  // Valor por defecto: mapa vacío.
  resource_servers = optional(map(object({   // (Opcional) Configuración de servidores de recursos para APIs.
    identifier = string,                     // Identificador único del servidor de recursos.
    name       = string,                     // Nombre descriptivo del servidor de recursos.
    scopes = optional(map(object({           // (Opcional) Scopes personalizados para el servidor de recursos.
      scope_name        = string,            // Nombre del scope.
      scope_description = string             // Descripción del scope.
    })), {})
  })), {})
  lambda_config = optional(object({          // (Opcional) Lambda triggers para personalizar el flujo de autenticación.
    pre_sign_up                    = optional(string, null) // ARN de Lambda ejecutada antes del registro.
    post_confirmation              = optional(string, null) // ARN de Lambda ejecutada después de la confirmación.
    pre_authentication             = optional(string, null) // ARN de Lambda ejecutada antes de la autenticación.
    post_authentication            = optional(string, null) // ARN de Lambda ejecutada después de la autenticación.
    custom_message                 = optional(string, null) // ARN de Lambda para personalizar mensajes (verificación, MFA).
    define_auth_challenge          = optional(string, null) // ARN de Lambda para definir retos de autenticación custom.
    create_auth_challenge          = optional(string, null) // ARN de Lambda para crear retos de autenticación custom.
    verify_auth_challenge_response = optional(string, null) // ARN de Lambda para verificar respuestas a retos custom.
    pre_token_generation           = optional(string, null) // ARN de Lambda ejecutada antes de generar tokens (permite modificar claims).
    user_migration                 = optional(string, null) // ARN de Lambda para migrar usuarios desde otro sistema.
  }), null)  // Valor por defecto: null (no se configura lambda_config).
})
```

### 🔹 Lambda Triggers disponibles

| Trigger | Descripción | Caso de uso |
|---------|-------------|-------------|
| `pre_sign_up` | Se ejecuta antes de registrar un usuario | Validaciones custom, auto-confirmación |
| `post_confirmation` | Se ejecuta después de confirmar un usuario | Enviar bienvenida, crear registros en BD |
| `pre_authentication` | Se ejecuta antes de autenticar | Validaciones adicionales, bloqueo por IP |
| `post_authentication` | Se ejecuta después de autenticar | Logging, analytics, actualizar último login |
| `custom_message` | Personaliza mensajes de verificación/MFA | Branding de emails, mensajes localizados |
| `define_auth_challenge` | Define el flujo de retos custom | Autenticación multi-factor personalizada |
| `create_auth_challenge` | Crea el reto de autenticación | Generar OTP, preguntas de seguridad |
| `verify_auth_challenge_response` | Verifica la respuesta al reto | Validar OTP, verificar respuestas |
| `pre_token_generation` | Modifica tokens antes de emitirlos | Agregar claims custom, roles dinámicos |
| `user_migration` | Migra usuarios de otro sistema | Migración gradual desde legacy auth |

### 📤 Outputs

| **Nombre**          | **Descripción** | **Sensible** |
|--------------------------|-----------------------------------------------------------------------------------------------------------|---|
| user_pool_ids            | IDs de los Cognito User Pools creados. | No |
| user_pool_domains        | Dominios configurados para cada User Pool. | No |
| user_pool_client_ids     | IDs de los clientes (app clients) creados para cada User Pool. | No |
| user_pool_client_secrets | Secrets de los clientes creados para cada User Pool. | **Sí** |
| identity_provider_ids    | IDs de los proveedores federados creados (si se han definido en la configuración del pool). | No |
| resource_server_ids      | IDs de los Resource Servers creados para cada User Pool. | No |
