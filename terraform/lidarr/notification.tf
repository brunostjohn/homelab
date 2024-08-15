resource "lidarr_notification_discord" "discord" {
  on_grab               = true
  on_import_failure     = true
  on_upgrade            = true
  on_rename             = true
  on_download_failure   = true
  on_track_retag        = true
  on_release_import     = true
  on_health_issue       = true
  on_application_update = true
  on_album_delete       = true
  on_artist_delete      = true
  on_health_restored    = true

  include_health_warnings = true
  name                    = "Discord"

  web_hook_url  = var.discord_webhook_url
  username      = "Lidarr"
  grab_fields   = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  import_fields = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
}