resource "lidarr_media_management" "mgmt" {
  unmonitor_previous_tracks = false
  hardlinks_copy            = true
  create_empty_folders      = false
  delete_empty_folders      = false
  watch_library_for_changes = true
  import_extra_files        = false
  set_permissions           = false
  skip_free_space_check     = false
  minimum_free_space        = 100
  recycle_bin_days          = 7
  chmod_folder              = "755"
  chown_group               = "1001"
  download_propers_repacks  = "preferAndUpgrade"
  allow_fingerprinting      = "newFiles"
  extra_file_extensions     = "srt"
  file_date                 = "none"
  recycle_bin_path          = ""
  rescan_after_refresh      = "always"
}

resource "lidarr_naming" "naming" {
  rename_tracks              = false
  replace_illegal_characters = true
  standard_track_format      = "{Album Title} ({Release Year})/{Artist Name} - {Album Title} - {track:00} - {Track Title}"
  multi_disc_track_format    = "{Album Title} ({Release Year})/{Medium Format} {medium:00}/{Artist Name} - {Album Title} - {track:00} - {Track Title}"
  artist_folder_format       = "{Artist Name}"
}

resource "lidarr_root_folder" "media" {
  name                    = "Media"
  path                    = "/data/media/music"
  monitor_option          = "all"
  metadata_profile_id     = 2
  quality_profile_id      = 1
  new_item_monitor_option = "all"
}