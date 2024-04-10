variable "aws_account_id" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "projects" {
  type = list(object({
    name        = string
    github_org  = string
    github_repo = string
  }))
  description = "managed snowflake project"
}
