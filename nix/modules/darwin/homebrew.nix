{
  homebrew = {
    enable = true;

    brews = [
      "mas"
    ];

    masApps = {
      "Infuse • Video Player" = 1136220934;
      "Messenger" = 1480068668;
      "Spark Mail – AI Email & Inbox" = 6445813049;
      "Microsoft Word" = 462054704;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Day One" = 1055511498;
      "Goodnotes 6" = 1444383602;
      "NordVPN: VPN Fast & Secure" = 905953485;
    };

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    casks = [
      "visual-studio-code"
      "arc"
      "discord"
      "warp"
      "adobe-creative-cloud"
      "figma"
      "figma-agent"
      "slack"
      "bambu-studio"
      "orcaslicer"
      "lens"
      "nextcloud"
      "autodesk-fusion"
      "zoom"
      "signal"
      "orbstack"
      "qbittorrent"
      "zed"
      "notion"
      "linear-linear"
      "microsoft-teams"
    ];
  };
}
