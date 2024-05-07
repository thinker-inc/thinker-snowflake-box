locals {

  # Snowflake Users
  initial_user_password = "2tK4Z@fZAwkjqzDZbZTh"
  _users_yml            = yamldecode(file("${path.root}/definitions/users.yml"))
  users                 = local._users_yml["users"] != null ? local._users_yml["users"] : []
}
