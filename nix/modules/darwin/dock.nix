{
  imports = [
    ./dockModule.nix
  ];

  local.dock = {
    enable = true;

    entries = [
      { path = "/System/Applications/Launchpad.app/"; }
      { path = "/Applications/Arc.app/"; }
      { path = "/Applications/Slack.app/"; }
      { path = "/Applications/zoom.us.app/"; }
      { path = "/Applications/Messenger.app/"; }
      { path = "/Applications/Discord.app/"; }
      { path = "/Applications/Signal.app/"; }
      { path = "/System/Applications/Messages.app/"; }
      { path = "/Applications/Spark Desktop.app/"; }
      { path = "/System/Applications/Calendar.app/"; }
      { path = "/Applications/Microsoft Word.app/"; }
      { path = "/Applications/Microsoft Excel.app/"; }
      { path = "/Applications/Microsoft PowerPoint.app/"; }
      { path = "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/"; }
      { path = "/System/Applications/Reminders.app/"; }
      { path = "/System/Applications/Notes.app/"; }
      { path = "/System/Applications/Music.app/"; }
      { path = "/Applications/Infuse.app/"; }
      { path = "/Users/brunostjohn/Applications/Autodesk Fusion.app/"; }
      { path = "/Applications/OrcaSlicer.app/"; }
      { path = "/Applications/BambuStudio.app/"; }
      { path = "/Applications/Adobe Lightroom CC/Adobe Lightroom.app/"; }
      { path = "/Applications/Adobe Premiere Pro 2024/Adobe Premiere Pro 2024.app/"; }
      { path = "/Applications/Adobe Photoshop 2024/Adobe Photoshop 2024.app/"; }
      { path = "/Applications/Adobe Illustrator 2024/Adobe Illustrator.app/"; }
      { path = "/Applications/Figma.app/"; }
      { path = "/Applications/Notion.app/"; }
      { path = "/Applications/Day One.app/"; }
      { path = "/Applications/Linear.app"; }
      { path = "/Applications/Zed.app/"; }
      { path = "/Applications/Visual Studio Code.app/"; }
      { path = "/Applications/Warp.app/"; }
      { path = "/Applications/OrbStack.app/"; }
      { path = "/Applications/Lens.app/"; }
      { path = "/System/Applications/System Settings.app/"; }
      {
        path = "/Users/brunostjohn/Downloads";
        section = "others";
        options = "--sort dateadded --view fan --display folder";
      }
    ];
  };
}
