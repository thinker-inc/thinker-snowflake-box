
# TODO: [Feature]: Support snowflake_service_user TYPE property
# https://github.com/Snowflake-Labs/terraform-provider-snowflake/issues/2951
# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/service_user

resource "snowflake_service_user" "this" {
  name         = upper(var.name)
  login_name   = var.login_name
  comment      = var.comment
  disabled     = var.disabled
  display_name = var.display_name
  # email        = var.email

  default_warehouse              = var.default_warehouse
  default_secondary_roles_option = var.default_secondary_roles_option
  default_role                   = var.default_role
  # default_namespace              = var.default_namespace

  # mins_to_unlock = 9
  # days_to_expiry = 8

  rsa_public_key   = var.rsa_public_key
  rsa_public_key_2 = var.rsa_public_key_2

  lifecycle {
    ignore_changes = [
      rsa_public_key,
      rsa_public_key_2,
      network_policy,
      default_secondary_roles_option
    ]
  }
}
