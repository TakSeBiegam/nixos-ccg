{self}: ({
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = let
    import-keys = pkgs.writeShellScriptBin "import-keys" ''
      umask 077
      ${pkgs.gnupg}/bin/gpg --import ${self}/gpg/install-key.asc
      cp ${self}/gpg/sshcontrol ''${HOME}/.gnupg/sshcontrol
    '';
  in [pkgs.git pkgs.gnupg import-keys];
  networking.wireless = {
    enable = false;
    iwd.enable = true;
  };
  users.users.nixos.openssh.authorizedKeys.keys = ["ssh-ed25519 XXX user@example.org"];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };
  security.pam.services.nixos.gnupg.enable = true;
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };
  isoImage.makeEfiBootable = true;
})
