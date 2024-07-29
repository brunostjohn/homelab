{
  services.samba = {
    enable = true;
    enableNmbd = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
            server string = Zefir's Storage
              workgroup = WORKGROUP
              server role = standalone server
              dns proxy = no
              vfs objects = catia fruit streams_xattr

              pam password change = yes
              map to guest = bad user
              usershare allow guests = yes
              create mask = 0664
              force create mode = 0664
              directory mask = 0775
              force directory mode = 0775
              follow symlinks = yes
              load printers = no
              printing = bsd
              printcap name = /dev/null
              disable spoolss = yes
              strict locking = no
              aio read size = 0
              aio write size = 0
              vfs objects = acl_xattr catia fruit streams_xattr
              inherit permissions = yes
      		getwd cache = yes
      		socket options = TCP_NODELAY IPTOS_THROUGHPUT SO_RCVBUF=131072 SO_SNDBUF=131072
      		acl allow execute always = true
      		acl map full control = yes
      		deadtime = 30
      		strict sync = no
      		sync always = no
      		use sendfile = yes
      		min receivefile size = 16384

              client ipc max protocol = SMB3
              client ipc min protocol = SMB2_10
              client max protocol = SMB3
              client min protocol = SMB2_10
              server max protocol = SMB3
              server min protocol = SMB2_10
    '';
  };

  services.samba.shares."Zefir's Share" = {
    path = "/mnt/jabberwock/files/share";
    browseable = "yes";
    "writable" = "yes";
    "read only" = "no";
    "guest ok" = "yes";
    "create mask" = "0644";
    "directory mask" = "0755";
    "force user" = "root";
    "veto files" =
      "/.apdisk/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/";
  };

  services.samba.shares."Klaudia's Share" = {
    path = "/mnt/jabberwock/files/klaudiasshare";
    browseable = "yes";
    "writable" = "yes";
    "read only" = "no";
    "guest ok" = "no";
    "create mask" = "0644";
    "directory mask" = "0755";
    "force user" = "root";
    "valid users" = "klaudia";
    "veto files" =
      "/.apdisk/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/";
  };

  services.samba.shares."Bruno's Share" = {
    path = "/mnt/jabberwock/files/brunosshare";
    browseable = "yes";
    "writable" = "yes";
    "read only" = "no";
    "guest ok" = "no";
    "create mask" = "0644";
    "directory mask" = "0755";
    "force user" = "root";
    "valid users" = "bruno";
    "veto files" =
      "/.apdisk/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/";
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  users.users.bruno = { isNormalUser = true; };

  users.users.klaudia = { isNormalUser = true; };
}
