output "name" {
  description = "Name of the network rule."
  value       = snowflake_network_rule.this.name
}

output "fully_qualified_name" {
  description = "Fully qualified name of the network rule."
  value       = snowflake_network_rule.this.fully_qualified_name
}

