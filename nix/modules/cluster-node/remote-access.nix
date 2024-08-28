{
  services.openssh.enable = true;
  users.users.brunostjohn.openssh.authorizedKeys.keys = [

  ];
  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "brunostjohn";
}
