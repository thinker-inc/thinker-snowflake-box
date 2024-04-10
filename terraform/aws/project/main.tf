module "common" {
  source         = "../modules/common"
  aws_account_id = local.aws_account_id
  aws_region     = local.aws_region
  projects       = local.projects
}

module "projects" {
  source         = "../modules/projects"
  aws_account_id = local.aws_account_id
  aws_region     = local.aws_region
  projects       = local.projects
}
