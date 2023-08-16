# # create masking policy
# resource "snowflake_masking_policy" "masking_policies" {
#   for_each = {
#     for policy in var.policies : policy.name => {
#         policy_name         = policy.policy_name
#         database            = policy.database
#         schema              = policy.schema
#         masking_expression  = policy.masking_expression
#         return_data_type    = policy.return_data_type
#         signature           = policy.signature

#         comment                 = contains(keys(policy), "comment") ? policy.comment : ""
#         exempt_other_policies   = contains(keys(policy), "exempt_other_policies") ? policy.exempt_other_policies : false
#         if_not_exists           = contains(keys(policy), "if_not_exists") ? policy.if_not_exists : true
#         or_replace              = contains(keys(policy), "or_replace") ? policy.or_replace : true
#     }
#     if policy.type == "MASKING"
#   }
#   name                = upper(each.value.policy_name)
#   database            = upper(each.value.database)
#   schema              = upper("${terraform.workspace}_${each.value.schema}")
#   masking_expression  = each.value.masking_expression
#   return_data_type    = each.value.return_data_type

#   signature {
#     dynamic "column" {
#       for_each = each.value.signature
#       content {
#         name = column.value.name
#         type = column.value.type
#       }
#     }
#   }

#   comment                 = each.value.comment
#   exempt_other_policies   = each.value.exempt_other_policies
#   if_not_exists           = each.value.if_not_exists
#   or_replace              = each.value.or_replace

#   depends_on = [snowflake_database.databases, snowflake_schema.schemas]
# }

# # 作成したマスキングポリシーの適用は別途記載が必要
# # resource "snowflake_table_column_masking_policy_application" "apply_masking_policy" {
# #   table          = "dev_ldw.dev_test.tablename"
# #   column         = "L_SHIPMODE"
# #   masking_policy = "policy"

# #   depends_on = [snowflake_masking_policy.masking_policies]
# # }

# resource "snowflake_row_access_policy" "example_row_access_policy" {
#   name     = "EXAMPLE_ROW_ACCESS_POLICY"
#   database = "EXAMPLE_DB"
#   schema   = "EXAMPLE_SCHEMA"
#   signature = {
#     A = "VARCHAR",
#     B = "VARCHAR"
#   }
#   row_access_expression = "case when current_role() in ('ANALYST') then true else false end"
# }