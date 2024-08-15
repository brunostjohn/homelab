resource "sonarr_media_management" "media_mgmt" {
  unmonitor_previous_episodes = false
  hardlinks_copy              = true
  create_empty_folders        = false
  delete_empty_folders        = false
  enable_media_info           = true
  import_extra_files          = false
  set_permissions             = false
  skip_free_space_check       = false
  minimum_free_space          = 100
  recycle_bin_days            = 7
  chmod_folder                = "755"
  chown_group                 = "1001"
  download_propers_repacks    = "preferAndUpgrade"
  episode_title_required      = "always"
  extra_file_extensions       = "srt"
  file_date                   = "none"
  recycle_bin_path            = ""
  rescan_after_refresh        = "always"
}

resource "sonarr_naming" "naming" {
  rename_episodes            = false
  replace_illegal_characters = true
  multi_episode_style        = 5
  colon_replacement_format   = 4
  daily_episode_format       = "{Series Title} - {Air-Date} - {Episode Title} {Quality Full}"
  anime_episode_format       = "{Series Title} - S{season:00}E{episode:00} - {Episode Title} {Quality Full}"
  series_folder_format       = "{Series Title}"
  season_folder_format       = "Season {season}"
  specials_folder_format     = "Specials"
  standard_episode_format    = "{Series Title} - S{season:00}E{episode:00} - {Episode Title} {Quality Full}"
}

resource "sonarr_root_folder" "root" {
  path = "/data/media/shows"
}