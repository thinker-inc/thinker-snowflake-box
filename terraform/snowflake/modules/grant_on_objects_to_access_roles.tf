# ##################################
# ### account object privileges (WAREHOUSE | DATABASE)
# ##################################
resource "snowflake_grant_privileges_to_account_role" "warehouse" {
  for_each = {
    for grant in var.warehouse_privileges : grant.index => grant if grant.type == "WAREHOUSE"
  }
  account_role_name = upper("${each.value.role_name}")
  privileges        = each.value.privileges
  on_account_object {
    object_type = each.value.type
    object_name = upper("${each.value.warehouse}")
  }

  depends_on = [snowflake_warehouse.warehouses, snowflake_role.roles]
}

resource "snowflake_grant_privileges_to_account_role" "database" {
  for_each = {
    for grant in var.database_privileges : grant.index => grant if grant.type == "DATABASE"
  }
  account_role_name = upper("${each.value.role_name}")
  privileges        = each.value.privileges
  on_account_object {
    object_type = each.value.type
    object_name = upper("${each.value.database}")
  }

  depends_on = [snowflake_warehouse.warehouses, snowflake_database.simple, snowflake_role.roles]
}

# ##################################
# ### schema privileges
# ##################################
# # schema privileges

# list of privileges
resource "snowflake_grant_privileges_to_account_role" "on_schema_grant" {
  for_each = {
    for grant in var.schema_privileges : "${grant.index}_on_schema_grant" => grant if grant.type == "SCHEMA"
  }
  account_role_name = upper("${each.value.role_name}")
  privileges        = each.value.privileges
  on_schema {
    schema_name = upper("${each.value.database}.${each.value.schema_name}")
  }

  depends_on = [snowflake_database.simple, snowflake_schema.schemas, snowflake_role.roles]
}

# future schemas in database
resource "snowflake_grant_privileges_to_account_role" "future_schema_grant" {
  for_each = {
    for grant in var.future_schemas_privieges : "${grant.index}_future_schema_grant" => grant if grant.type == "SCHEMA"
  }
  account_role_name = upper("${each.value.role_name}")
  privileges        = each.value.feature_schema_privileges

  on_schema {
    future_schemas_in_database = upper("${each.value.database}")
  }

  depends_on = [snowflake_database.simple, snowflake_schema.schemas, snowflake_role.roles]
}

# ##################################
# ### schema object privileges
# ##################################

# all in schema
resource "snowflake_grant_privileges_to_account_role" "all_schema_object_in_schema_grant" {
  for_each = {
    for grant in var.schema_privileges : "${grant.index}_all_schema_object_in_schema_grant" => grant if grant.type == "SCHEMA"
  }
  account_role_name = upper("${each.value.role_name}")
  privileges        = each.value.table_privileges
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = upper("${each.value.database}.${each.value.schema_name}")
    }
  }

  depends_on = [snowflake_database.simple, snowflake_schema.schemas, snowflake_role.roles]
}

# future in schema tables
resource "snowflake_grant_privileges_to_account_role" "future_schema_tables_in_schema_grant" {
  for_each = {
    for grant in var.schema_privileges :
    "${grant.index}_future_schema_tables_in_schema_grant" => grant
    if grant.type == "SCHEMA"
  }
  account_role_name = upper("${each.value.role_name}")
  privileges        = each.value.table_privileges
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = upper("${each.value.database}.${each.value.schema_name}")
    }
  }

  depends_on = [snowflake_database.simple, snowflake_schema.schemas, snowflake_role.roles]
}

resource "snowflake_grant_privileges_to_account_role" "future_schema_views_in_schema_grant" {
  for_each = {
    for grant in var.view_privileges :
    "${grant.index}_future_schema_views_in_schema_grant" => grant
    if grant.type == "VIEWS"
  }
  account_role_name = upper("${each.value.role_name}")
  privileges        = each.value.view_privileges
  on_schema_object {
    future {
      object_type_plural = "VIEWS"
      in_schema          = upper("${each.value.database}.${each.value.schema_name}")
    }
  }

  depends_on = [snowflake_database.simple, snowflake_schema.schemas, snowflake_role.roles]
}
