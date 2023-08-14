# Access role を Functional role に grant する
resource "snowflake_warehouse" "warehouses" {
  for_each = {
    for warehouse in var.warehouses : warehouse.name => {
      name                                = warehouse.name
      warehouse_size                      = warehouse.warehouse_size

      auto_suspend                        = contains(keys(warehouse), "auto_suspend") ? warehouse.auto_suspend : 60
      comment                             = contains(keys(warehouse), "comment") ? warehouse.comment : ""
      max_concurrency_level               = contains(keys(warehouse), "max_concurrency_level") ? warehouse.max_concurrency_level : 8
      statement_queued_timeout_in_seconds = contains(keys(warehouse), "statement_queued_timeout_in_seconds") ? warehouse.statement_queued_timeout_in_seconds : 0
      statement_timeout_in_seconds        = contains(keys(warehouse), "statement_timeout_in_seconds") ? warehouse.statement_timeout_in_seconds : 3600
      warehouse_type                      = contains(keys(warehouse), "warehouse_type") ? warehouse.warehouse_type : "STANDARD"

      enable_query_acceleration           = contains(keys(warehouse), "enable_query_acceleration") ? warehouse.enable_query_acceleration : false
      query_acceleration_max_scale_factor = contains(keys(warehouse), "query_acceleration_max_scale_factor") ? warehouse.query_acceleration_max_scale_factor : 8

      max_cluster_count                   = contains(keys(warehouse), "max_cluster_count") ? warehouse.max_cluster_count : 1
      min_cluster_count                   = contains(keys(warehouse), "min_cluster_count") ? warehouse.min_cluster_count : 1
    }
  }

  name                                = upper("${terraform.workspace}_${each.value.name}")

  auto_suspend                        = each.value.auto_suspend
  comment                             = each.value.comment
  max_concurrency_level               = each.value.max_concurrency_level
  statement_queued_timeout_in_seconds = each.value.statement_queued_timeout_in_seconds
  statement_timeout_in_seconds        = each.value.statement_timeout_in_seconds
  warehouse_type                      = each.value.warehouse_type

  enable_query_acceleration           = each.value.enable_query_acceleration
  query_acceleration_max_scale_factor = each.value.query_acceleration_max_scale_factor

  max_cluster_count                   = each.value.max_cluster_count
  min_cluster_count                   = each.value.min_cluster_count
}