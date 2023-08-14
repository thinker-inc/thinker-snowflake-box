# Access role を Functional role に grant する
resource "snowflake_warehouse" "warehouses" {
  for_each = {
    for warehouse in var.warehouses : warehouse.name => warehouse
  }

  name                                = upper("${terraform.workspace}_${each.value.name}")
  warehouse_size                      = each.value.warehouse_size

  auto_suspend                        = contains(keys(each.value), "auto_suspend") ? each.value.auto_suspend : 60
  comment                             = contains(keys(each.value), "comment") ? each.value.comment : ""
  max_concurrency_level               = contains(keys(each.value), "max_concurrency_level") ? each.value.max_concurrency_level : 8
  statement_queued_timeout_in_seconds = contains(keys(each.value), "statement_queued_timeout_in_seconds") ? each.value.statement_queued_timeout_in_seconds : 0
  statement_timeout_in_seconds        = contains(keys(each.value), "statement_timeout_in_seconds") ? each.value.statement_timeout_in_seconds : 3600
  warehouse_type                      = contains(keys(each.value), "each.value_type") ? each.value.each.value_type : "STANDARD"

  enable_query_acceleration           = contains(keys(each.value), "enable_query_acceleration") ? each.value.enable_query_acceleration : false
  query_acceleration_max_scale_factor = contains(keys(each.value), "query_acceleration_max_scale_factor") ? each.value.query_acceleration_max_scale_factor : 8

  max_cluster_count                   = contains(keys(each.value), "max_cluster_count") ? each.value.max_cluster_count : 1
  min_cluster_count                   = contains(keys(each.value), "min_cluster_count") ? each.value.min_cluster_count : 1
}