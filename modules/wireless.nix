{
  networking = {
    wireless.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
}
