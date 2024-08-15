resource "readarr_media_management" "media_mgmt" {
  unmonitor_previous_books    = false
  hardlinks_copy              = true
  create_empty_author_folders = false
  delete_empty_folders        = false
  watch_ibrary_for_changes    = true
  import_extra_files          = false
  set_permissions             = false
  skip_free_space_check       = false
  minimum_free_space          = 100
  recycle_bin_days            = 7
  chmod_folder                = "755"
  chown_group                 = "1001"
  download_propers_repacks    = "preferAndUpgrade"
  allow_fingerprinting        = "newFiles"
  extra_file_extensions       = "srt"
  file_date                   = "none"
  recycle_bin_path            = ""
  rescan_after_refresh        = "always"
}

resource "readarr_naming" "naming" {
  rename_books               = false
  replace_illegal_characters = true
  colon_replacement_format   = 4
  author_folder_format       = "{Author Name}"
  standard_book_format       = "{Book Title}/{Author Name} - {Book Title}{ (PartNumber)}"
}

resource "readarr_root_folder" "root_books" {
  name                            = "Books"
  default_metadata_profile_id     = 1
  default_monitor_option          = "all"
  default_quality_profile_id      = 1
  path                            = "/data/media/books/"
  is_calibre_library              = false
  default_monitor_new_item_option = "all"
  output_profile                  = "default"
}

resource "readarr_root_folder" "root_audiobooks" {
  name                            = "Audiobooks"
  default_metadata_profile_id     = 1
  default_monitor_option          = "all"
  default_quality_profile_id      = 2
  path                            = "/data/media/audiobooks/"
  is_calibre_library              = false
  default_monitor_new_item_option = "all"
  output_profile                  = "default"
}