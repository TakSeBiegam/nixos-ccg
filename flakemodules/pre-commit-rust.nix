{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];
  perSystem = {pkgs, ...}: {
    pre-commit = {
      # Currently nix flake check integration is kind of broken
      # as it's offline only
      check.enable = false;
      settings.hooks = {
        clippy = {
          enable = true;
          package = pkgs.rust-toolchain;
        };
        treefmt.enable = true;
      };
    };
  };
}
