output "grant_to_acount_authentication_policy" {
  description = "grant_to_acount_authentication_policy"
  value       = "policy_${var.apply_authentication_policy_role_name}"
}

output "grant_to_acount_network_policy" {
  description = "grant_to_acount_network_policy"
  value       = "network_policy_${var.create_network_policy_role_name}"
}
