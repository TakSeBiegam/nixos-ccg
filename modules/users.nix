{pkgs, ...}: {
  programs.zsh.enable = true;
  nix.settings.trusted-users = ["@wheel"];
  users = {
    mutableUsers = false;
    groups = {
      example = {};
    };
    users = {
      root.hashedPassword = "SOME_PASSWORD_HASH";

      example = {
        isNormalUser = true;
        group = "example";
        home = "/home/example";
        description = "Example User";
        extraGroups = ["wheel" "networkmanager" "input"];
        createHome = true;
        hashedPassword = "SOME_PASSWORD_HASH";
        openssh.authorizedKeys.keys = ["ssh-ed25519 XXXX user@example.org"];
        autoSubUidGidRange = true;
        shell = pkgs.zsh;
      };
    };
  };
}
