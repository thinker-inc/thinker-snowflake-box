# ##################################
# ### create masking policy
# ##################################
# resource "snowflake_masking_policy" "masking_policies" {
#   for_each = {
#     for policy in var.policies : policy.name => policy if policy.type == "MASKING"
#   }
#   name                = upper(each.value.policy_name)
#   database            = upper("${terraform.workspace}_${each.value.database}")
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

#   comment               = contains(keys(each.value), "comment") ? each.value.comment : ""
#   exempt_other_policies = contains(keys(each.value), "exempt_other_policies") ? each.value.exempt_other_policies : null
#   if_not_exists         = contains(keys(each.value), "if_not_exists") ? each.value.if_not_exists : null
#   or_replace            = contains(keys(each.value), "or_replace") ? each.value.or_replace : null

#   depends_on = [snowflake_database.databases, snowflake_schema.schemas]
# }

# ##################################
# ### create row access policy
# ##################################
# resource "snowflake_row_access_policy" "row_access_policies" {
#   for_each = {
#     for policy in var.policies : policy.name => policy if policy.type == "ROWACCESS"
#   }
#   name                  = upper(each.value.policy_name)
#   database              = upper("${terraform.workspace}_${each.value.database}")
#   schema                = upper("${terraform.workspace}_${each.value.schema}")
#   signature             = each.value.signature

#   row_access_expression = each.value.row_access_expression

#   comment               = contains(keys(each.value), "comment") ? each.value.comment : ""
# }