# warehouse privileges
resource "snowflake_grant_privileges_to_role" "on_warehouse_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      object_name   = grant.parameter.object_name
      privileges    = grant.parameter.privileges
    }
    if grant.class == "WAREHOUSE"
  }
  privileges = each.value.privileges
  role_name  = upper("${terraform.workspace}_${each.value.roles}")
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = upper("${terraform.workspace}_${each.value.object_name}")
  }
  # depends_on = [snowflake_role.roles]
}

# Database privileges
resource "snowflake_grant_privileges_to_role" "on_database_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      privileges    = grant.parameter.privileges
    }
    if grant.class == "DATABASE"
  }
  privileges = each.value.privileges
  role_name  = upper("${terraform.workspace}_${each.value.roles}")
  on_account_object {
    object_type = "DATABASE"
    object_name = upper("${each.value.database_name}")
  }
  # depends_on = [snowflake_role.roles, snowflake_database.databases]
}

# Future Schema in database privileges
resource "snowflake_grant_privileges_to_role" "future_schema_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      privileges    = grant.parameter.privileges
    }
    if grant.class == "FUTURE" && grant.type == "SCHEMA"
  }
  privileges  = each.value.privileges
  role_name   = upper("${terraform.workspace}_${each.value.roles}")
  on_schema {
    future_schemas_in_database = upper("${each.value.database_name}")
  }

  # depends_on = [snowflake_role.roles, snowflake_database.databases]
}

# Schema privileges
resource "snowflake_grant_privileges_to_role" "on_schema_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      schema_name   = grant.parameter.schema_name
      privileges    = grant.parameter.privileges
    }
    if grant.class == "SCHEMA"
  }
  privileges  = each.value.privileges
  role_name   = upper("${terraform.workspace}_${each.value.roles}")
  on_schema {
    schema_name = upper("${each.value.database_name}.${terraform.workspace}_${each.value.schema_name}")
  }

  # depends_on = [snowflake_role.roles, snowflake_database.databases, snowflake_schema.schemas]
}

# Schema Object privileges
resource "snowflake_grant_privileges_to_role" "on_schema_object" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      object_type   = grant.type
      database_name = grant.parameter.database_name
      schema_name   = grant.parameter.schema_name
      privileges    = grant.parameter.privileges
    }
    if grant.class == "SCHEMA_OBJECT"
  }
  privileges  = each.value.privileges
  role_name   = upper("${terraform.workspace}_${each.value.roles}")
  on_schema_object {
    all {
      object_type_plural = each.value.object_type
      in_schema          = upper("${each.value.database_name}.${terraform.workspace}_${each.value.schema_name}")
    }
  }
  # depends_on = [snowflake_role.roles, snowflake_database.databases, snowflake_schema.schemas]
}

# future Schema Object privileges
resource "snowflake_grant_privileges_to_role" "on_table" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      roles         = grant.role
      database_name = grant.parameter.database_name
      schema_name   = grant.parameter.schema_name
      privileges    = grant.parameter.privileges
    }
    if grant.class == "FUTURE" && grant.type != "SCHEMA"
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
  # depends_on = [snowflake_role.roles, snowflake_database.databases, snowflake_schema.schemas]
}