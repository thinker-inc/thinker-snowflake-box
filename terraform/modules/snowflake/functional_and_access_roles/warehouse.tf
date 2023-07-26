# Access role を Functional role に grant する
resource "snowflake_warehouse" "warehouses" {
  for_each = {
    for warehouse in var.warehouses :
    warehouse.name => warehouse
  }

  name                  = each.value.name
  comment               = each.value.comment
  warehouse_size        = each.value.warehouse_size
  min_cluster_count     = each.value.min_cluster_count
  max_cluster_count     = each.value.max_cluster_count
  auto_suspend          = each.value.auto_suspend
  initially_suspended   = true
  statement_timeout_in_seconds = 3600
}