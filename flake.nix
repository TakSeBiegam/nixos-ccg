{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-24.11;
    flake-parts.url = github:hercules-ci/flake-parts;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    disko = {
      url = github:nix-community/disko;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      withSystem,
      flake-parts-lib,
      ...
    }: {
      imports = let
        inherit (flake-parts-lib) importApply;
        server = {
          device = importApply ./devices/server {inherit withSystem;};
        };
      in [
        server.device
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        checks = {
          fmt-check = pkgs.stdenv.mkDerivation {
            name = "fmt-check";
            src = ./.;
            nativeBuildInputs = with pkgs; [alejandra];
            doCheck = true;
            checkPhase = ''
              alejandra -c .
            '';
            installPhase = ''
              mkdir -p $out
            '';
          };
        };
        formatter = pkgs.alejandra;
      };
      flake = {
        nixosConfigurations = let
          interactiveIso = {
            modules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
              (import ./modules/installation.nix {inherit self;})
            ];
          };
        in {
          interactiveIso-x86_64 =
            nixpkgs.lib.nixosSystem
            ({system = "x86_64-linux";} // interactiveIso);
          interactiveIso-aarch64 =
            nixpkgs.lib.nixosSystem
            ({system = "aarch64-linux";} // interactiveIso);
        };
      };
    });
}
