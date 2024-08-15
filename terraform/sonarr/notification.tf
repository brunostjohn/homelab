resource "sonarr_notification_discord" "discord" {
  on_grab                            = true
  on_download                        = true
  on_upgrade                         = true
  on_rename                          = true
  on_series_delete                   = true
  on_episode_file_delete             = true
  on_episode_file_delete_for_upgrade = true
  on_health_issue                    = true
  on_application_update              = true
  on_health_restored                 = true
  on_manual_interaction_required     = true
  on_series_add                      = true

  include_health_warnings = true
  name                    = "Discord"

  web_hook_url  = var.discord_webhook_url
  username      = "Sonarr"
  grab_fields   = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  import_fields = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
}