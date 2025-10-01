# **🚀 Módulo Terraform para Cognito: cloudops-ref-repo-aws-cognito-terraform**

## Descripción:

Este módulo de Terraform permite la creación de múltiples **Cognito User Pools** en AWS, incluyendo la configuración de dominios, clientes (app clients) y la opción de agregar proveedores de identidad federados (por ejemplo, Google y Facebook) de forma opcional. Con este módulo, podrás gestionar de forma centralizada la infraestructura de autenticación de tus aplicaciones.

---

## Características

- **Múltiples User Pools:** Permite crear varios pools de usuarios según las necesidades de tu aplicación.
- **Configuración de Dominio:** Asigna a cada pool su propio dominio (utilizando el dominio predeterminado de Cognito o uno personalizado mediante un certificado ACM).
- **Clientes Asociados:** Define múltiples clientes para cada pool, configurando flujos OAuth, scopes, URLs de callback y logout.
- **Proveedores Federados Opcionales:** Habilita la autenticación a través de proveedores externos (por ejemplo, Google y Facebook) de forma opcional.

---

Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo

El módulo cuenta con la siguiente estructura:

```bash
cloudops-ref-repo-aws-rds-terraform/
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
      domain          = "xxxx"  
      certificate_arn = ""             # Vacío para usar el dominio predeterminado

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

      # Configuración de clientes para este pool
      clients = {
        clienteWeb = {
          name                         = "xxxx"
          generate_secret              = true
          allowed_oauth_flows          = ["xxxx"]
          allowed_oauth_scopes         = ["xxxx"]
          callback_urls                = ["xxxx"]
          logout_urls                  = ["xxxx"]
          supported_identity_providers = ["xxxx"]
          explicit_auth_flows          = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
          allowed_oauth_flows_user_pool_client = true
        }
        clienteMobile = {
          name                         = "xxxx"
          generate_secret              = false
          allowed_oauth_flows          = ["xxxx"]
          allowed_oauth_scopes         = ["xxxx"]
          callback_urls                = ["xxxx"]
          logout_urls                  = []
          supported_identity_providers = []
          explicit_auth_flows          = []
          allowed_oauth_flows_user_pool_client = false
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
Contiene la configuración para cada Cognito User Pool. Cada entrada del mapa define un pool con sus propiedades, clientes y (opcionalmente) proveedores de identidad federados.

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
  certificate_arn = string                   // ARN del certificado ACM para dominios personalizados (vacío para usar el dominio predeterminado).
  clients = map(object({                      // Configuración de los clientes (app clients) asociados al pool.
    name                         = string,    // Nombre del cliente.
    generate_secret              = bool,      // Indica si se debe generar un secret.
    allowed_oauth_flows          = list(string), // Flujos OAuth permitidos (ejemplo: ["implicit"] o ["code"]).
    allowed_oauth_scopes         = list(string), // Scopes permitidos (ejemplo: ["email", "openid"]).
    callback_urls                = list(string), // Lista de URLs de callback.
    logout_urls                  = list(string), // Lista de URLs de logout.
    supported_identity_providers = optional(list(string), []) // (Opcional) Lista de proveedores federados soportados (ejemplo: ["Google", "Facebook"]).
    explicit_auth_flows          = optional(list(string), []) // (Opcional) Flujos de autenticación explícitos (ejemplo: ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]).
    allowed_oauth_flows_user_pool_client = optional(bool, false) // (Opcional) Habilita características OAuth 2.0. Debe ser true para usar callback_urls, logout_urls, allowed_oauth_scopes y allowed_oauth_flows.
  }))
  federated_identity_providers = optional(map(object({  // (Opcional) Configuración de proveedores de identidad federados.
    provider_type     = string,            // Tipo de proveedor (ejemplo: "Google" o "Facebook").
    provider_name     = string,            // Nombre que se usará en Cognito (ejemplo: "Google").
    client_id         = string,            // Client ID obtenido al registrar la aplicación en el proveedor.
    client_secret     = string,            // Client Secret correspondiente.
    authorize_scopes  = string,            // Scopes autorizados (ejemplo: "email profile").
    attribute_mapping = map(string)        // Mapeo de atributos entre el proveedor y Cognito (ejemplo: { email = "email", username = "sub" }).
  })), {})  // Valor por defecto: mapa vacío.
})
```

### 📤 Outputs

| **Nombre**          | **Descripción**                                                                                           |
|--------------------------|-----------------------------------------------------------------------------------------------------------|
| user_pool_ids            | IDs de los Cognito User Pools creados.                                                                    |
| user_pool_domains        | Dominios configurados para cada User Pool.                                                                |
| user_pool_client_ids     | IDs de los clientes (app clients) creados para cada User Pool.                                             |
| identity_provider_ids    | IDs de los proveedores federados creados (si se han definido en la configuración del pool).                |

