{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      flakeCheck = true;
      programs = {
        alejandra.enable = true;
        mdformat.enable = true;
        rustfmt.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        toml-sort.enable = true;
        yamlfmt.enable = true;
      };
    };
  };
}
