{self}: ({
  config,
  pkgs,
  lib,
  ...
}: let
  import-keys = pkgs.writeShellScriptBin "import-keys" ''
    umask 077
    ${pkgs.gnupg}/bin/gpg --import ${self}/gpg/install-key.asc
    cp ${self}/gpg/sshcontrol ''${HOME}/.gnupg/sshcontrol
  '';
in {
  environment.systemPackages = [
    pkgs.git
    pkgs.git-lfs
    pkgs.gnupg
    pkgs.helix
    import-keys
  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };
  security.pam.services.nixos.gnupg.enable = true;
})
