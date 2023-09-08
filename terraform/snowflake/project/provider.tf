# 基本的に全て環境変数から入れること。github actionsでも良いし、GCP,AWS,Azure,terraform cloud etc...なんでもOK
provider "snowflake" {
    account   = "RZ61527"
    username  = "TERRAFORM_USER"
    password  = "**********" 
    region    = "ap-northeast-1.aws"
    role      = "TERRAFORM"
    warehouse = "TERRAFORM_WH"
}