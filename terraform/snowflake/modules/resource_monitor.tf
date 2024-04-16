##################################
### create resource monitor
##################################
resource "snowflake_resource_monitor" "standard_monitors" {
  for_each = {
    for monitor in var.standard_monitors : monitor.name => monitor if monitor.name != null
  }
  name                      = upper("${each.value.name}")
  set_for_account           = each.value.set_for_account
  credit_quota              = each.value.credit_quota
  frequency                 = upper("${each.value.frequency}")
  start_timestamp           = each.value.start_timestamp
  notify_triggers           = [for notify_trigger in each.value.notify_triggers : notify_trigger]
  suspend_trigger           = each.value.suspend_trigger
  suspend_immediate_trigger = each.value.suspend_immediate_trigger
  notify_users              = [for notify_user in each.value.notify_users : ("${notify_user}")]
  warehouses                = [for warehouse in each.value.warehouses : upper("${warehouse}")]

  depends_on = [snowflake_warehouse.warehouses]

  lifecycle {
    ignore_changes = [
      start_timestamp
    ]
  }
}
