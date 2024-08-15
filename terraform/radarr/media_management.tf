resource "radarr_media_management" "mgmt" {
  copy_using_hardlinks                        = true
  recycle_bin                                 = ""
  import_extra_files                          = false
  delete_empty_folders                        = false
  skip_free_space_check_when_importing        = false
  recycle_bin_cleanup_days                    = 7
  minimum_free_space_when_importing           = 100
  file_date                                   = "none"
  chmod_folder                                = "755"
  download_propers_and_repacks                = "preferAndUpgrade"
  auto_unmonitor_previously_downloaded_movies = false
  set_permissions_linux                       = false
  paths_default_static                        = false
  chown_group                                 = "1001"
  enable_media_info                           = true
  rescan_after_refresh                        = "always"
  extra_file_extensions                       = "srt"
  auto_rename_folders                         = false
  create_empty_movie_folders                  = false
}

resource "radarr_naming" "naming" {
  rename_movies              = false
  replace_illegal_characters = true
  colon_replacement_format   = "delete"
  standard_movie_format      = "{Movie Title} ({Release Year}) {Quality Full}"
  movie_folder_format        = "{Movie Title} ({Release Year})"
}

resource "radarr_root_folder" "root" {
  path = "/data/media/movies"
}