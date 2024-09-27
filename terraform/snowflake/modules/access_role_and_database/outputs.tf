output "name" {
  description = "Name of the database."
  value       = snowflake_database.this.name
}

output "fully_qualified_name" {
  description = "Fully qualified name of the database."
  value       = snowflake_database.this.fully_qualified_name
}
