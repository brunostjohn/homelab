resource "readarr_notification_discord" "discord" {
  on_grab                         = true
  on_download_failure             = true
  on_upgrade                      = true
  on_rename                       = true
  on_import_failure               = true
  on_book_delete                  = true
  on_book_file_delete             = true
  on_book_file_delete_for_upgrade = true
  on_health_issue                 = true
  on_book_retag                   = true
  on_author_delete                = true
  on_release_import               = true
  on_application_update           = true

  include_health_warnings = true
  name                    = "Discord"

  web_hook_url = var.discord_webhook_url
  username     = "Readarr"
}