locals {
  # 設定ファイルをロード
  users_yml = yamldecode(
    file("${path.root}/yaml/users.yml")
  )

  databases_yml = yamldecode(
    file("${path.root}/yaml/databases.yml")
  )

  functional_roles_yml = yamldecode(
    file("${path.root}/yaml/functional_roles.yml")
  )

  access_roles_yml = yamldecode(
    file("${path.root}/yaml/access_roles.yml")
  )

  access_roles_to_functional_roles_yml = yamldecode(
    file("${path.root}/yaml/access_roles_to_functional_roles.yml")
  )

  warehouses_yml = yamldecode(
    file("${path.root}/yaml/warehouses.yml")
  )

  # user のリスト
  users = local.users_yml["users"]

  # database のリスト
  databases = local.databases_yml["databases"]

  # schemaのリスト
  schemas = local.databases_yml["schemas"]
  # Functional role のリスト
  functional_roles = local.functional_roles_yml["functional_roles"]
  # grant Functional role to ユーザーのリスト
  grant_functional_roles_to_user = flatten(local.functional_roles_yml["grant_functional_roles_to_user"])

  # Access role のリスト
  access_roles = flatten(local.access_roles_yml["access_roles"])
  # grant ... on objects to Access role のリスト
  grant_on_object_to_access_role = flatten(local.access_roles_yml["grant_on_object_to_access_role"])


  # grant Access role to Functional role のリスト
  grant_access_role_to_functional_role = flatten(local.access_roles_to_functional_roles_yml["grant_access_roles_to_functional_roles"])
  
  # warehouse のリスト
  warehouses = local.warehouses_yml["warehouses"]

}