resource "aws_s3_bucket" "terraform_state" {
  for_each = {
    for key, project in var.projects : project.name => project
  }

  bucket = lower("terraform-state-${each.value.name}")


  tags = {
    Name = lower("${each.value.name}")
    #Environment = "prd"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  for_each = {
    for key, project in var.projects : project.name => project
  }

  name         = "${each.value.name}-terraform-state-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST" // On-demandモード

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_policy" "terraform_state" {
  for_each = {
    for key, project in var.projects : project.name => project
  }

  name        = lower("${each.value.name}-terraform-state-policy")
  description = "Policy for Terraform state"
  policy = templatefile("${path.module}/templates/terraform_state_iam_policy.json", {
    bucket_name = lower("terraform-state-${each.value.name}"),
    table_name  = aws_dynamodb_table.terraform_state_lock[each.value.name].name
  })
}
