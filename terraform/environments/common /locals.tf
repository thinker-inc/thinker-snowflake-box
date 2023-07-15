locals {
  # 設定ファイルをロード
  access_roles_yml = yamldecode(
    file("${path.root}/yaml/access_roles.yml")
  )

  functional_roles_yml = yamldecode(
    file("${path.root}/yaml/functional_roles.yml")
  )

  users_yml = yamldecode(
    file("${path.root}/yaml/users.yml")
  )

  access_roles_to_functional_roles_yml = yamldecode(
    file("${path.root}/yaml/access_roles_to_functional_roles.yml")
  )

  # Access role のリスト
  access_roles = flatten(local.access_roles_yml["access_roles"])
  # Functional role のリスト
  functional_roles = local.functional_roles_yml["functional_roles"]
  # user のリスト
  users = local.users_yml["users"]
  # grant Access role to Functional role のリスト
  grant_access_role_to_functional_role = flatten(local.access_roles_to_functional_roles_yml["grant_access_roles_to_functional_roles"])

}