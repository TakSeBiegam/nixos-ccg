{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users = {
    test = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      password = "";
    };
  };

  system.stateVersion = "24.11";
}
