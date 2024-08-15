resource "prowlarr_notification_discord" "webhook" {
  name         = "Discord"
  web_hook_url = var.discord_webhook_url

  on_health_issue       = true
  on_application_update = true
  on_health_restored    = true
  on_grab               = true

  grab_fields = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  username = "Prowlarr"
}