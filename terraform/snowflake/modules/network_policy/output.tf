output "name" {
  description = "Name of the policy"
  value       = snowflake_network_policy.this.name
}

output "fully_qualified_name" {
  description = "Fully qualified name of the policy name"
  value       = snowflake_network_policy.this.fully_qualified_name
}

