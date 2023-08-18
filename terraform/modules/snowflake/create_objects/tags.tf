# create tag
resource "snowflake_tag" "tag" {
  for_each = {
    for tag in var.tags : tag.name => tag
  }
  name      = upper(each.value.tag_name)
  database  = upper(each.value.database)
  schema    = upper("${terraform.workspace}_${each.value.schema}")

  allowed_values  = contains(keys(each.value), "allowed_values") ? each.value.allowed_values : null
  comment         = contains(keys(each.value), "comment") ? each.value.comment : ""

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}
