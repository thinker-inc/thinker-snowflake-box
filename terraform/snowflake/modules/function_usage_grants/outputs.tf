output "all_functions_usage_ids" {
  description = "Grant resource IDs for ALL FUNCTIONS USAGE."
  value       = { for k, v in snowflake_grant_privileges_to_account_role.all_functions_usage : k => v.id }
}

output "future_functions_usage_ids" {
  description = "Grant resource IDs for FUTURE FUNCTIONS USAGE."
  value       = { for k, v in snowflake_grant_privileges_to_account_role.future_functions_usage : k => v.id }
}

