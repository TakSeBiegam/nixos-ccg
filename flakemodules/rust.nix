{inputs, ...}: let
  overlays = [
    (import inputs.rust-overlay)
    (self: super:
      assert !(super ? rust-toolchain); rec {
        rust-toolchain = super.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      })
  ];
in {
  perSystem = {
    system,
    pkgs,
    lib,
    inputs',
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system overlays;
      config = {};
    };
  };
}
