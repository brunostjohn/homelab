resource "readarr_download_client_qbittorrent" "qbittorrent" {
  name                       = "qBittorrent"
  host                       = "qbittorrent.entertainment.svc.cluster.local"
  port                       = 8080
  username                   = "admin"
  password                   = var.qbittorrent_password
  enable                     = true
  priority                   = 1
  book_category              = "Books"
  book_imported_category     = "Books (Imported)"
  initial_state              = 0
  recent_book_priority       = 1
  remove_completed_downloads = true
  remove_failed_downloads    = true
  older_book_priority        = 0
}