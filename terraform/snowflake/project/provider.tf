provider "snowflake" {
  #account = var.SNOWFLAKE_ACCOUNT
  # user     = var.SNOWFLAKE_USERNAME
  # password = var.SNOWFLAKE_PASSWORD
  # region    = var.SNOWFLAKE_REGION
  role = "TERRAFORM"
  #role = var.SNOWFLAKE_ROLE
  # warehouse = var.SNOWFLAKE_WAREHOUSE
}
