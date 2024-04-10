locals {

  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region

  # github_actions_oidc_arn = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
  # github_org              = "thinker-inc"
  # github_repo             = "terraform-template"

  projects_yml = yamldecode(file("${path.root}/projects/projects.yml"))
  projects     = local.projects_yml["projects"]

}
