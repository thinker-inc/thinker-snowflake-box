# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/authentication_policy

resource "snowflake_authentication_policy" "this" {
  database                   = var.database
  schema                     = var.schema
  name                       = upper(var.name)
  authentication_methods     = var.authentication_methods
  mfa_authentication_methods = var.mfa_authentication_methods
  mfa_enrollment             = var.mfa_enrollment
  client_types               = var.client_types
  security_integrations      = var.security_integrations
  comment                    = var.comment
}

# Attach the Account
resource "snowflake_account_authentication_policy_attachment" "account" {
  count                 = var.is_account ? 1 : 0
  authentication_policy = snowflake_authentication_policy.this.fully_qualified_name
}

# Atach User
resource "snowflake_user_authentication_policy_attachment" "users" {
  for_each                   = var.users
  authentication_policy_name = snowflake_authentication_policy.this.fully_qualified_name
  user_name                  = upper(each.value)
}
