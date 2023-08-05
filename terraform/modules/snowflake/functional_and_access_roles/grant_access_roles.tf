# on Database
resource "snowflake_grant_privileges_to_role" "on_database_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      privileges    = grant.parameter.privileges
    }
    if grant.type == "DATABASE" #|| true
  }
  privileges = each.value.privileges
  role_name  = upper("${terraform.workspace}_${each.value.roles}")
  on_account_object {
    object_type = "DATABASE"
    object_name = upper("${each.value.database_name}")
  }
  depends_on = [snowflake_role.roles, snowflake_database.databases]
}

# on Schema
resource "snowflake_grant_privileges_to_role" "on_schema_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      schema_name   = grant.parameter.schema_name
      privileges    = grant.parameter.privileges
    }
    if grant.type == "SCHEMA"
  }
  privileges  = each.value.privileges
  role_name   = upper("${terraform.workspace}_${each.value.roles}")
  on_schema {
    schema_name = upper("${each.value.database_name}.${terraform.workspace}_${each.value.schema_name}")
  }

  depends_on = [snowflake_role.roles, snowflake_database.databases, snowflake_schema.schemas]
}

# on Existing Table
resource "snowflake_grant_privileges_to_role" "on_existing_table" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      schema_name   = grant.parameter.schema_name
      privileges    = grant.parameter.privileges
    }
    if grant.type == "EXISTING_TABLE"
  }
  privileges  = each.value.privileges
  role_name   = upper("${terraform.workspace}_${each.value.roles}")
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = upper("${each.value.database_name}.${terraform.workspace}_${each.value.schema_name}")
    }
  }
  depends_on = [snowflake_role.roles, snowflake_database.databases, snowflake_schema.schemas]
}

# on future table
resource "snowflake_grant_privileges_to_role" "on_table" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      schema_name   = grant.parameter.schema_name
      privileges    = grant.parameter.privileges
    }
    if grant.type == "TABLE"
  }
  privileges  = each.value.privileges
  role_name   = upper("${terraform.workspace}_${each.value.roles}")
  on_schema_object{
    future{
      object_type_plural = "TABLES"
      in_schema          = upper("${each.value.database_name}.${terraform.workspace}_${each.value.schema_name}")
    }
  }
  # 先に存在しなければならないが、参照していないので依存関係を付ける
  depends_on = [snowflake_role.roles, snowflake_database.databases, snowflake_schema.schemas]
}

# on view
resource "snowflake_grant_privileges_to_role" "on_view" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      schema_name   = grant.parameter.schema_name
      privileges    = grant.parameter.privileges
    }
    if grant.type == "VIEW"
  }
  privileges  = each.value.privileges
  role_name   = upper("${terraform.workspace}_${each.value.roles}")
  on_schema_object{
    future{
      object_type_plural = "VIEWS"
      in_schema          = upper("${each.value.database_name}.${terraform.workspace}_${each.value.schema_name}")
    }
  }
  # 先に存在しなければならないが、参照していないので依存関係を付ける
  depends_on = [snowflake_role.roles, snowflake_database.databases, snowflake_schema.schemas]
}

# on warehouse
resource "snowflake_grant_privileges_to_role" "on_warehouse_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      object_name   = grant.parameter.object_name
      privileges    = grant.parameter.privileges
    }
    if grant.type == "WAREHOUSE"
  }
  privileges = each.value.privileges
  role_name  = upper("${terraform.workspace}_${each.value.roles}")
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = upper("${terraform.workspace}_${each.value.object_name}")
  }
  depends_on = [snowflake_role.roles]
}

# on task

# on pipe