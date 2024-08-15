resource "lidarr_metadata_kodi" "kodi_meta" {
  enable          = true
  name            = "Kodi"
  artist_metadata = true
  album_images    = true
  artist_images   = true
  album_metadata  = true
}

resource "lidarr_metadata_roksbox" "roksboks_meta" {
  enable         = true
  name           = "Roksbox Meta"
  album_images   = true
  artist_images  = true
  track_metadata = true
}