# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:
# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
{
  lib,
  config,
  self,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs disko nixos-hardware;
in {
  flake = {
    nixosConfigurations = {
      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration.nix
          ## Disk layout
          disko.nixosModules.disko
          ./disk-config.nix
          ./configuration.nix

          ## Enable flake support
          ../../modules/flake.nix

          ## Speak polish please
          ../../modules/localization.nix
          ../../modules/stationary.nix

          ## SSH access
          ../../modules/sshd.nix

          ## My system users
          ../../modules/users.nix

          ## GC and store optimization
          ../../modules/hygiene.nix

          ## Nginx
          ../../modules/nginx.nix

          ## Node 22
          ../../modules/nodejs_22.nix

          ## Git
          ../../modules/git.nix

          ## Apps
          ../../apps/projects.nix
        ];
      };
    };
  };
}
