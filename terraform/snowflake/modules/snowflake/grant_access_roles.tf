##################################
### global privileges
##################################
resource "snowflake_grant_privileges_to_role" "on_global_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => grant if grant.class == "GLOBAL"
  }
  privileges = each.value.parameter.privileges
  role_name  = upper("${terraform.workspace}_${each.value.role}")
  on_account = true

  depends_on = [snowflake_role.roles]
}

##################################
### account object privileges (WAREHOUSE | DATABASE | INTEGRATION)
##################################
resource "snowflake_grant_privileges_to_role" "on_account_object_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => grant  if grant.class == "ACCOUNT OBJECT"
  }
  privileges = each.value.parameter.privileges
  role_name  = upper("${terraform.workspace}_${each.value.role}")
  on_account_object {
    object_type = each.value.type
    object_name = upper("${terraform.workspace}_${each.value.parameter.object_name}")
  }

  depends_on = [
    snowflake_role.roles,
    snowflake_database.databases,
    snowflake_warehouse.warehouses
    ]
}

##################################
### schema privileges
##################################
# schema privileges
resource "snowflake_grant_privileges_to_role" "on_schema_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => grant if grant.class == "SCHEMA" && grant.type == "SCHEMA"
  }
  privileges  = each.value.parameter.privileges
  role_name   = upper("${terraform.workspace}_${each.value.role}")
  on_schema {
    schema_name = upper("${terraform.workspace}_${each.value.parameter.database_name}.${terraform.workspace}_${each.value.parameter.schema_name}")
  }

  depends_on = [
    snowflake_role.roles,
    snowflake_database.databases,
    snowflake_schema.schemas
    ]
}

# future schema privileges
resource "snowflake_grant_privileges_to_role" "future_schema_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => grant if grant.class == "FUTURE" && grant.type == "SCHEMA"
  }
  privileges  = each.value.parameter.privileges
  role_name   = upper("${terraform.workspace}_${each.value.role}")
  on_schema {
    future_schemas_in_database = upper("${terraform.workspace}_${each.value.parameter.database_name}")
  }

  depends_on = [
    snowflake_role.roles,
    snowflake_database.databases,
    snowflake_schema.schemas
    ]
}

##################################
### schema object privileges
##################################
# schema object privileges
resource "snowflake_grant_privileges_to_role" "on_schema_object_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => grant if grant.class == "SCHEMA OBJECT"
  }
  privileges  = each.value.parameter.privileges
  role_name   = upper("${terraform.workspace}_${each.value.role}")
  on_schema_object {
    all {
      object_type_plural = each.value.type
      in_schema          = upper("${terraform.workspace}_${each.value.parameter.database_name}.${terraform.workspace}_${each.value.parameter.schema_name}")
    }
  }
  
  
  depends_on = [
    snowflake_role.roles,
    snowflake_database.databases,
    snowflake_schema.schemas
    ]
}

# future schema object in database privileges
resource "snowflake_grant_privileges_to_role" "future_schema_object_in_database_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => grant if grant.class == "FUTURE" && grant.type != "SCHEMA" && grant.parameter.privileges_level == "DATABASE"
  }
  privileges  = each.value.parameter.privileges
  role_name   = upper("${terraform.workspace}_${each.value.role}")
  on_schema_object {
    all {
      object_type_plural = each.value.type
      in_database        = upper("${terraform.workspace}_${each.value.parameter.database_name}")
    }
  }

  depends_on = [
    snowflake_role.roles,
    snowflake_database.databases,
    snowflake_schema.schemas
    ]
}

# future schema object in schema privileges
resource "snowflake_grant_privileges_to_role" "future_schema_object_in_schema_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => grant if grant.class == "FUTURE" && grant.type != "SCHEMA" && grant.parameter.privileges_level == "SCHEMA"
  }
  privileges  = each.value.parameter.privileges
  role_name   = upper("${terraform.workspace}_${each.value.role}")
  on_schema_object {
    all {
      object_type_plural = each.value.type
      in_schema          = upper("${terraform.workspace}_${each.value.parameter.database_name}.${terraform.workspace}_${each.value.parameter.schema_name}")
    }
  }
  
  depends_on = [
    snowflake_role.roles,
    snowflake_database.databases,
    snowflake_schema.schemas
    ]
}