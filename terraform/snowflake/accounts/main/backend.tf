terraform {

  backend "s3" {
  #   bucket       = "terraform-state-thinker-snowflake-standard"
  #   key          = "terraform/resource/snowflake.tfstate"
  #   encrypt      = "true"
  #   region       = "ap-northeast-1"
  #   use_lockfile = true
  # }

  backend "local" {
    path = "terraform.tfstate"
  }
}
