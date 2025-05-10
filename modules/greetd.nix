{
  config,
  pkgs,
  lib,
  ...
}: let
  greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
    include /etc/sway/config.d/*

    input "type:touchpad" {
      tap enabled
    }
    seat seat0 xcursor_theme Bibata-Modern-Classic 24

    xwayland disable

    bindsym XF86MonBrightnessUp exec light -A 5
    bindsym XF86MonBrightnessDown exec light -U 5
    bindsym Print exec ${lib.getExe pkgs.grim} /tmp/greet.png
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

    exec "${lib.getExe config.programs.regreet.package}; swaymsg exit"
  '';
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.sway.package}/bin/sway --config ${greetdSwayConfig}";
      };
    };
  };
  programs.regreet.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
