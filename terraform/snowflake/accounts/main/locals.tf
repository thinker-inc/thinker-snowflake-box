locals {

  # Snowflake Roles
  security_role_name = "FR_SECURITY_MANAGER"

  # マネージャーグループ
  manager = [
    "RYOTA_HASEGAWA",
    "KUNJIE_HUANG",
    "LEE@THINKER-INC.JP"
  ]

  # 分析利用者
  analytics_users = [
    "SAKAMUNE@THINKER-INC.JP",
    "MIYAHARA@THINKER-INC.JP"
  ]

}
