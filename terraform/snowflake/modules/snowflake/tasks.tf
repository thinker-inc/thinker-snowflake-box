##################################
### create task
##################################
resource "snowflake_task" "task" {
  for_each = {
    for task in var.tasks : task.name => task
  }
  name          = upper(each.value.task_name)
  database      = upper("${terraform.workspace}_${each.value.database}")
  schema        = upper("${terraform.workspace}_${each.value.schema}")
  sql_statement = each.value.sql_statement

  warehouse     = contains(keys(each.value), "warehouse") ? each.value.warehouse : null
  user_task_managed_initial_warehouse_size = contains(keys(each.value), "user_task_managed_initial_warehouse_size") ? each.value.user_task_managed_initial_warehouse_size: null

  after                       = contains(keys(each.value), "after") ? each.value.after : null
  schedule                    = contains(keys(each.value), "schedule") ? each.value.schedule : null

  comment                     = contains(keys(each.value), "comment") ? each.value.comment : ""
  allow_overlapping_execution = contains(keys(each.value), "allow_overlapping_execution") ? each.value.allow_overlapping_execution : false
  enabled                     = contains(keys(each.value), "enabled") ? each.value.enabled : true
  error_integration           = contains(keys(each.value), "error_integration") ? each.value.error_integration : null
  user_task_timeout_ms        = contains(keys(each.value), "user_task_timeout_ms") ? each.value.user_task_timeout_ms : 3600000
  when                        = contains(keys(each.value), "when") ? each.value.when : null

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}