##################################
### create warehouse
##################################
resource "snowflake_warehouse" "warehouses" {
  for_each = {
    for warehouse in var.warehouses : warehouse.name => warehouse
  }

  name                         = upper("${each.value.name}")
  warehouse_size               = upper("${each.value.warehouse_size}")
  auto_suspend                 = contains(keys(each.value), "auto_suspend") ? each.value.auto_suspend : 60
  auto_resume                  = contains(keys(each.value), "auto_resume") ? each.value.auto_resume : true
  comment                      = contains(keys(each.value), "comment") ? each.value.comment : ""
  max_cluster_count            = contains(keys(each.value), "max_cluster_count") ? each.value.max_cluster_count : 1
  min_cluster_count            = contains(keys(each.value), "min_cluster_count") ? each.value.min_cluster_count : 1
  initially_suspended          = contains(keys(each.value), "initially_suspended") ? each.value.initially_suspended : true
  statement_timeout_in_seconds = contains(keys(each.value), "statement_timeout_in_seconds") ? each.value.statement_timeout_in_seconds : 3600 # 1 hour
  warehouse_type               = contains(keys(each.value), "warehouse_type") ? each.value.warehouse_type : "STANDARD"
}
