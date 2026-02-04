# FUNCTION USAGE grants for UDF/UDTF execution
#
# Snowflake may return `Unknown user-defined table function` when the calling role lacks FUNCTION USAGE.
# This module grants USAGE on ALL/FUTURE FUNCTIONS in the specified schemas to the specified account roles.

locals {
  function_usage_grants = {
    for pair in setproduct(var.account_role_names, var.in_schemas) :
    "${pair[0]}|${pair[1]}" => {
      account_role_name = pair[0]
      in_schema         = pair[1]
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "all_functions_usage" {
  for_each = local.function_usage_grants

  account_role_name = each.value.account_role_name
  privileges        = ["USAGE"]

  on_schema_object {
    all {
      object_type_plural = "FUNCTIONS"
      in_schema          = each.value.in_schema
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "future_functions_usage" {
  for_each = local.function_usage_grants

  account_role_name = each.value.account_role_name
  privileges        = ["USAGE"]

  on_schema_object {
    future {
      object_type_plural = "FUNCTIONS"
      in_schema          = each.value.in_schema
    }
  }
}

