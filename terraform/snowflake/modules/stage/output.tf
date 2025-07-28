output "name" {
  description = "Name of the snowflake_stage."
  value       = snowflake_stage.this.name
}

output "fully_qualified_name" {
  description = "Fully qualified name of the snowflake_stage."
  value       = snowflake_stage.this.fully_qualified_name
} 
