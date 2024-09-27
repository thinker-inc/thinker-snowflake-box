# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/account_password_policy_attachment
# password policy
resource "snowflake_password_policy" "default" {
  name     = var.password_policy_name
  database = var.databse
  schema   = var.schema
  comment  = var.comment


  max_age_days = var.max_age_days
  min_length   = var.min_length
}

resource "snowflake_account_password_policy_attachment" "attachment" {
  password_policy = snowflake_password_policy.default.fully_qualified_name
}
