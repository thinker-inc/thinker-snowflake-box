output "name" {
  description = "Name of the password policy."
  value       = snowflake_password_policy.default.name
}

output "fully_qualified_name" {
  description = "Fully qualified name of the password policy."
  value       = snowflake_password_policy.default.fully_qualified_name
}

