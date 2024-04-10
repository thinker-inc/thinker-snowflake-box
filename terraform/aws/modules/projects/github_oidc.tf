resource "aws_iam_role" "github_actions" {
  for_each = {
    for key, project in var.projects : project.name => project
  }

  name = lower("${each.value.name}--oidc-github-actions-role")
  assume_role_policy = templatefile("${path.module}/templates/github_actions_iam_role_policy.json", {
    aws_account_id = var.aws_account_id,
    github_org     = each.value.github_org,
    github_repo    = each.value.github_repo,
  })

  managed_policy_arns = [aws_iam_policy.terraform_state["${each.value.name}"].arn]
}

# OIDC に使用する ID プロバイダを AWS で作成します
data "http" "github_actions_openid_configuration" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "tls_certificate" "github_actions" {
  url = jsondecode(data.http.github_actions_openid_configuration.response_body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.github_actions.certificates[*].sha1_fingerprint
}
