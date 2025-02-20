output "user_pool_ids" {
  description = "IDs de los Cognito User Pools creados"
  value       = { for k, pool in aws_cognito_user_pool.pool : k => pool.id }
}

output "user_pool_domains" {
  description = "Dominio configurado para cada User Pool"
  value       = { for k, domain in aws_cognito_user_pool_domain.domain : k => domain.domain }
}

output "user_pool_client_ids" {
  description = "IDs de los clientes creados para cada User Pool"
  value       = { for k, client in aws_cognito_user_pool_client.client : k => client.id }
}

output "identity_provider_ids" {
  description = "IDs de los proveedores federados creados (si existen)"
  value       = { for k, idp in aws_cognito_identity_provider.identity : k => idp.id }
}