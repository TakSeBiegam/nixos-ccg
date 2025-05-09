{pkgs, ...}: {
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  environment.systemPackages = [pkgs.libsecret];
}
