locals {
  # ++++++++++ create_objects ++++++++++
  # ----- user -----
  users_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/users.yml")),
    {users:[]}
  )
  users_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/users.yml")),
    {users:[]}
  )

  users = concat(
    try(local.users_yml["users"], []),
    try(local.users_env_yml["users"], [])
  )

  # ----- functional role -----
  functional_roles_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/functional_roles.yml")),
    {functional_roles:[], grant_functional_roles_to_user:[]}
  )
  functional_roles_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/functional_roles.yml")),
    {functional_roles:[], grant_functional_roles_to_user:[]}
  )

  functional_roles = concat(
    try(local.functional_roles_yml["functional_roles"], []),
    try(local.functional_roles_env_yml["functional_roles"], [])
  )

  # ----- access role -----
  access_roles_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/access_roles.yml")),
    {access_roles: [], grant_on_object_to_access_role:[]}
  )
  access_roles_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/access_roles.yml")),
    {access_roles: [], grant_on_object_to_access_role:[]}
  )

  access_roles = concat(
    try(local.access_roles_yml["access_roles"], []),
    try(local.access_roles_env_yml["access_roles"], [])
  )

  # ----- warehouse -----
  warehouses_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/warehouses.yml")),
    {warehouses:[]}
  )
  warehouses_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/warehouses.yml")),
    {warehouses:[]}
  )

  warehouses = concat(
    try(local.warehouses_yml["warehouses"], []),
    try(local.warehouses_env_yml["warehouses"], [])
  )

  # ----- database -----
  databases_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/databases.yml")),
    {databases:[]}
  )
  databases_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/databases.yml")),
    {databases:[]}
  )

  databases = concat(
    try(local.databases_yml["databases"], []),
    try(local.databases_env_yml["databases"], [])
  )

  # ----- schema -----
  schemas_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/schemas.yml")),
    {schemas:[]}
  )
  schemas_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/schemas.yml")),
    {schemas:[]}
  )

  schemas = concat(
    try(local.schemas_yml["schemas"], []),
    try(local.schemas_env_yml["schemas"], [])
  )

  # ----- fileformat -----
  fileformats_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/fileformats.yml")),
    {fileformats:[]}
  )
  fileformats_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/fileformats.yml")),
    {fileformats:[]}
  )

  fileformats = concat(
    try(local.fileformats_yml["fileformats"], []),
    try(local.fileformats_env_yml["fileformats"], [])
  )

  # ----- pipe -----
  pipes_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/pipes.yml")),
    {pipes:[]}
  )
  pipes_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/pipes.yml")),
    {pipes:[]}
  )

  pipes = concat(
    try(local.pipes_yml["pipes"], []),
    try(local.pipes_env_yml["pipes"], [])
  )

  # ----- policy -----
    policies_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/policies.yml")),
    {policies:[]}
  )
  policies_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/policies.yml")),
    {policies:[]}
  )

  policies = concat(
    try(local.policies_yml["policies"], []),
    try(local.policies_env_yml["policies"], [])
  )

  # ----- tag -----
  tags_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/tags.yml")),
    {tags:[]}
  )
  tags_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/tags.yml")),
    {tags:[]}
  )

  tags = concat(
    try(local.tags_yml["tags"], []),
    try(local.tags_env_yml["tags"], [])
  )

  # ----- stage -----
  stages_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/stages.yml")),
    {stages:[]}
  )
  stages_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/stages.yml")),
    {stages:[]}
  )

  stages = concat(
    try(local.stages_yml["stages"], []),
    try(local.stages_env_yml["stages"], [])
  )

  # ----- stream -----
  streams_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/streams.yml")),
    {streams:[]}
  )
  streams_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/streams.yml")),
    {streams:[]}
  )

  streams = concat(
    try(local.streams_yml["streams"], []),
    try(local.streams_env_yml["streams"], [])
  )

  # ----- external table -----
  external_tables_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/external_tables.yml")),
    {external_tables:[]}
  )
  external_tables_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/external_tables.yml")),
    {external_tables:[]}
  )

  external_tables = concat(
    try(local.external_tables_yml["external_tables"], []),
    try(local.external_tables_env_yml["external_tables"], [])
  )

  # ----- task -----
  tasks_yml = try(
    yamldecode(file("${path.root}/yaml/common/create_objects/tasks.yml")),
    {tasks:[]}
  )
  tasks_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/create_objects/tasks.yml")),
    {tasks:[]}
  )

  tasks = concat(
    try(local.tasks_yml["tasks"], []),
    try(local.tasks_env_yml["tasks"], [])
  )


  # ++++++++++ grant_roles ++++++++++
  # ----- access roles to functional roles -----
  access_roles_to_functional_roles_yml = try(
    yamldecode(file("${path.root}/yaml/common/grant_roles/access_roles_to_functional_roles.yml")),
    {grant_access_roles_to_functional_roles:[]}
  )

  access_roles_to_functional_roles_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/grant_roles/access_roles_to_functional_roles.yml")),
    {grant_access_roles_to_functional_roles:[]}
  )

  grant_access_role_to_functional_role = concat(
    try(local.access_roles_to_functional_roles_yml["grant_access_roles_to_functional_roles"], []),
    try(local.access_roles_to_functional_roles_env_yml["grant_access_roles_to_functional_roles"], [])
  )

  # ----- functional roles to users -----
  functional_roles_to_users_yml = try(
    yamldecode(file("${path.root}/yaml/common/grant_roles/functional_roles_to_users.yml")),
    {functional_roles_to_users:[]}
  )
  functional_roles_to_users_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/grant_roles/functional_roles_to_users.yml")),
    {functional_roles_to_users:[]}
  )

  grant_functional_roles_to_user = concat(
    try(local.functional_roles_to_users_yml["functional_roles_to_users"], []),
    try(local.functional_roles_to_users_env_yml["functional_roles_to_users"], [])
  )


  # ++++++++++ privileges_to_roles ++++++++++
  # ----- warehouse privileges -----
  warehouse_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/warehouse_privileges.yml")),
    {warehouse_privileges:[]}
  )
  warehouse_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/warehouse_privileges.yml")),
    {warehouse_privileges:[]}
  )

  warehouse_privileges = concat(
    try(local.warehouse_privileges_yml["warehouse_privileges"], []),
    try(local.warehouse_privileges_env_yml["warehouse_privileges"], [])
  )

  # ----- database privileges -----
  database_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/database_privileges.yml")),
    {database_privileges:[]}
  )
  database_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/database_privileges.yml")),
    {database_privileges:[]}
  )

  database_privileges = concat(
    try(local.database_privileges_yml["database_privileges"], []),
    try(local.database_privileges_env_yml["database_privileges"], [])
  )

  # ----- schema privileges -----
  schema_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/schema_privileges.yml")),
    {schema_privileges:[]}
  )
  schema_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/schema_privileges.yml")),
    {schema_privileges:[]}
  )

  schema_privileges = concat(
    try(local.schema_privileges_yml["schema_privileges"], []),
    try(local.schema_privileges_env_yml["schema_privileges"], [])
  )

  # ----- fileformat privileges -----
  fileformat_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/fileformat_privileges.yml")),
    {fileformat_privileges:[]}
  )
  fileformat_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/fileformat_privileges.yml")),
    {fileformat_privileges:[]}
  )

  fileformat_privileges = concat(
    try(local.fileformat_privileges_yml["fileformat_privileges"], []),
    try(local.fileformat_privileges_env_yml["fileformat_privileges"], [])
  )

  # ----- pipe privileges -----
  pipe_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/pipe_privileges.yml")),
    {pipe_privileges:[]}
  )
  pipe_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/pipe_privileges.yml")),
    {pipe_privileges:[]}
  )

  pipe_privileges = concat(
    try(local.pipe_privileges_yml["pipe_privileges"], []),
    try(local.pipe_privileges_env_yml["pipe_privileges"], [])
  )

  # ----- stage privileges -----
  stage_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/stage_privileges.yml")),
    {stage_privileges:[]}
  )
  stage_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/stage_privileges.yml")),
    {stage_privileges:[]}
  )

  stage_privileges = concat(
    try(local.stage_privileges_yml["stage_privileges"], []),
    try(local.stage_privileges_env_yml["stage_privileges"], [])
  )

  # ----- stream privileges -----
  stream_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/stream_privileges.yml")),
    {stream_privileges:[]}
  )
  stream_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/stream_privileges.yml")),
    {stream_privileges:[]}
  )

  stream_privileges = concat(
    try(local.stream_privileges_yml["stream_privileges"], []),
    try(local.stream_privileges_env_yml["stream_privileges"], [])
  )

  # ----- external_table privileges -----
  external_table_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/external_table_privileges.yml")),
    {external_table_privileges:[]}
  )
  external_table_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/external_table_privileges.yml")),
    {external_table_privileges:[]}
  )

  external_table_privileges = concat(
    try(local.external_table_privileges_yml["external_table_privileges"], []),
    try(local.external_table_privileges_env_yml["external_table_privileges"], [])
  )

  # ----- task privileges -----
  task_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/task_privileges.yml")),
    {task_privileges:[]}
  )
  task_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/task_privileges.yml")),
    {task_privileges:[]}
  )

  task_privileges = concat(
    try(local.task_privileges_yml["task_privileges"], []),
    try(local.task_privileges_env_yml["task_privileges"], [])
  )

  # ----- future privileges -----
  future_privileges_yml = try(
    yamldecode(file("${path.root}/yaml/common/privileges_to_role/future_privileges.yml")),
    {future_privileges:[]}
  )
  future_privileges_env_yml = try(
    yamldecode(file("${path.root}/yaml/${terraform.workspace}/privileges_to_role/future_privileges.yml")),
    {future_privileges:[]}
  )

  future_privileges = concat(
    try(local.future_privileges_yml["future_privileges"], []),
    try(local.future_privileges_env_yml["future_privileges"], [])
  )

  grant_on_object_to_access_role = concat(
    local.warehouse_privileges,
    local.database_privileges,
    local.schema_privileges,
    local.fileformat_privileges,
    local.pipe_privileges,
    local.stage_privileges,
    local.stream_privileges,
    local.external_table_privileges,
    local.task_privileges,
    local.future_privileges
  )
}