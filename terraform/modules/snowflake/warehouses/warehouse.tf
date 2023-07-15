# Access role を Functional role に grant する
resource "snowflake_warehouse" "warehouses" {
  for_each = {
    for warehouse in var.warehouses :
    warehouse.name => warehouse
  }
  
  name    = each.value.name
  comment = each.value.comment
  warehouse_size = each.value.warehouse_size
}