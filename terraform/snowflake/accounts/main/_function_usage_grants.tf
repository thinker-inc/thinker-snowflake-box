# ########################
# # FUNCTION USAGE grants (Looker Studio / TROCCO)
# ########################
#
# ビュー内で参照される UDF/UDTF（例: DWH.INT.GET_FISCAL_PERIODS）を実行するには、
# 呼び出しロールに FUNCTION の USAGE が必要になるケースがある。
# `Unknown user-defined table function` が出る場合、存在確認に加えて権限不足も疑う。
#
# 影響範囲を最小化するため、対象スキーマ配下の ALL/FUTURE FUNCTIONS に対して
# 必要なロールへ USAGE を付与する。
#
# NOTE:
# - plan に MFA/Authentication Policy 等の差分が混ざり得るため、apply は -target で
#   本ファイルの grant リソースのみを適用する前提。

locals {
  # 権限不足が出た関数: DWH.INT.GET_FISCAL_PERIODS
  #（Looker Studio 対応と同じスキーマ範囲）
  function_usage_schemas = [
    "\"MART\".\"TABLEAU_BI\"",
    "\"DWH\".\"INT\"",
  ]

  trocco_function_usage_roles = {
    import      = module.sr_trocco_import.name
    spreadsheet = module.sr_trocco_spreadsheet.name
  }

  trocco_function_usage_grants = {
    for pair in setproduct(keys(local.trocco_function_usage_roles), local.function_usage_schemas) :
    "${pair[0]}|${pair[1]}" => {
      account_role_name = local.trocco_function_usage_roles[pair[0]]
      in_schema         = pair[1]
    }
  }
}

# ########################
# # Looker Studio
# ########################
resource "snowflake_grant_privileges_to_account_role" "looker_studio_all_functions_usage" {
  provider = snowflake.fr_security_manager

  for_each = toset(local.function_usage_schemas)

  account_role_name = module.sr_looker_studio.name
  privileges        = ["USAGE"]

  on_schema_object {
    all {
      object_type_plural = "FUNCTIONS"
      in_schema          = each.value
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "looker_studio_future_functions_usage" {
  provider = snowflake.fr_security_manager

  for_each = toset(local.function_usage_schemas)

  account_role_name = module.sr_looker_studio.name
  privileges        = ["USAGE"]

  on_schema_object {
    future {
      object_type_plural = "FUNCTIONS"
      in_schema          = each.value
    }
  }
}

# ########################
# # TROCCO
# ########################
resource "snowflake_grant_privileges_to_account_role" "trocco_all_functions_usage" {
  provider = snowflake.fr_security_manager

  for_each = local.trocco_function_usage_grants

  account_role_name = each.value.account_role_name
  privileges        = ["USAGE"]

  on_schema_object {
    all {
      object_type_plural = "FUNCTIONS"
      in_schema          = each.value.in_schema
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "trocco_future_functions_usage" {
  provider = snowflake.fr_security_manager

  for_each = local.trocco_function_usage_grants

  account_role_name = each.value.account_role_name
  privileges        = ["USAGE"]

  on_schema_object {
    future {
      object_type_plural = "FUNCTIONS"
      in_schema          = each.value.in_schema
    }
  }
}

