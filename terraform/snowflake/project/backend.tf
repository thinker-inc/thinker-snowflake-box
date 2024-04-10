terraform {

  backend "s3" {
    bucket         = "terraform-state-thinker-snowflake-standard"
    key            = "terraform/resource/snowflake.tfstate"
    encrypt        = "true"
    region         = "ap-northeast-1"
    dynamodb_table = "thinker-snowflake-standard-terraform-state-lock"
    profile        = "thinker-snowflake-terraform"
  }

  # backend "local" {
  #   path = "terraform.tfstate"
  # }
}
