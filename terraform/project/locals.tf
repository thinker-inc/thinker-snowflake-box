locals {
  # 設定ファイルをロード
  users_yml = try(
    yamldecode(file("${path.root}/yaml/common/users.yml")),
    {users:[]}
  )

  users_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/users.yml")),
    {users:[]}
  )

  databases_yml = try(
    yamldecode(file("${path.root}/yaml/common/databases.yml")),
    {databases:[], schemas:[]}
  )

  databases_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/databases.yml")),
    {databases:[], schemas:[]}
  )

  functional_roles_yml = try(
    yamldecode(file("${path.root}/yaml/common/functional_roles.yml")),
    {functional_roles:[], grant_functional_roles_to_user:[]}
  )

  functional_roles_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/functional_roles.yml")),
    {functional_roles:[], grant_functional_roles_to_user:[]}
  )

  access_roles_yml = try(
    yamldecode(file("${path.root}/yaml/common/access_roles.yml")),
    {access_roles: [], grant_on_object_to_access_role:[]}
  )

  access_roles_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/access_roles.yml")),
    {access_roles: [], grant_on_object_to_access_role:[]}
  )

  access_roles_to_functional_roles_yml = try(
    yamldecode(file("${path.root}/yaml/common/access_roles_to_functional_roles.yml")),
    {grant_access_roles_to_functional_roles:[]}
  )

  access_roles_to_functional_roles_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/access_roles_to_functional_roles.yml")),
    {grant_access_roles_to_functional_roles:[]}
  )

  warehouses_yml = try(
    yamldecode(file("${path.root}/yaml/common/warehouses.yml")),
    {warehouses:[]}
  )

  warehouses_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/warehouses.yml")),
    {warehouses:[]}
  )

  # user のリスト
  users = concat(
    try(local.users_yml["users"], []),
    try(local.users_env_yml["users"], [])
  )

  # database のリスト
  databases = concat(
    try(local.databases_yml["databases"], []),
    try(local.databases_env_yml["databases"], [])
  )

  # schemaのリスト
  schemas = concat(
    try(local.databases_yml["schemas"], []),
    try(local.databases_env_yml["schemas"], [])
  )

  # Functional role のリスト
  functional_roles = concat(
    try(local.functional_roles_yml["functional_roles"], []),
    try(local.functional_roles_env_yml["functional_roles"], [])
  )

  # grant Functional role to ユーザーのリスト
  grant_functional_roles_to_user = concat(
    try(local.functional_roles_yml["grant_functional_roles_to_user"], []),
    try(local.functional_roles_env_yml["grant_functional_roles_to_user"], [])
  )

  # Access role のリスト
  access_roles = concat(
    try(local.access_roles_yml["access_roles"], []),
    try(local.access_roles_env_yml["access_roles"], [])
  )
  # grant ... on objects to Access role のリスト
  grant_on_object_to_access_role = concat(
    try(local.access_roles_yml["grant_on_object_to_access_role"], []),
    try(local.access_roles_env_yml["grant_on_object_to_access_role"], [])
  )

  # grant Access role to Functional role のリスト
  grant_access_role_to_functional_role = concat(
    try(local.access_roles_to_functional_roles_yml["grant_access_roles_to_functional_roles"], []),
    try(local.access_roles_to_functional_roles_env_yml["grant_access_roles_to_functional_roles"], [])
  )

  # warehouse のリスト
  warehouses = concat(
    try(local.warehouses_yml["warehouses"], []),
    try(local.warehouses_env_yml["warehouses"], [])
  )
}