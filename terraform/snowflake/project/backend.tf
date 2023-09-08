########プロバイダー設定########
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# # Configure the AWS Provider
# provider "aws" {
#   region = "ap-northeast-1"
# }
########################

########backend 設定########
terraform {
  backend "local" {}

#   backend "s3" {
#     bucket                     = "bucket-name"
#     key                        = "path/to/my/key"
#     workspace_key_prefix       = "hogehoge"
#     region                     = "ap-northeast-1"
#     dynamodb_table             = "fuga"
#   }
}
########################