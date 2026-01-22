# ########################
# # Looker Studio: FUNCTION USAGE grants
# ########################
#
# ビュー内で参照されるUDF（FUNCTION）を実行するには、呼び出しロールに USAGE が必要になるケースがある。
# 影響範囲を最小化するため、ReadOnlyのDBロール全体ではなく Looker Studio 用のロール
# `SR_LOOKER_STUDIO` のみに付与する。
#
# NOTE:
# - MFA/Authentication Policy の差分は apply しない前提（-target でこのリソースだけ適用する）

locals {
  # 権限不足が出た関数: DWH.INT.GET_FISCAL_PERIODS
  looker_studio_function_usage_schemas = [
    "\"MART\".\"TABLEAU_BI\"",
    "\"DWH\".\"INT\"",
  ]
}

resource "snowflake_grant_privileges_to_account_role" "looker_studio_all_functions_usage" {
  provider = snowflake.fr_security_manager

  for_each = toset(local.looker_studio_function_usage_schemas)

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

  for_each = toset(local.looker_studio_function_usage_schemas)

  account_role_name = module.sr_looker_studio.name
  privileges        = ["USAGE"]

  on_schema_object {
    future {
      object_type_plural = "FUNCTIONS"
      in_schema          = each.value
    }
  }
}
