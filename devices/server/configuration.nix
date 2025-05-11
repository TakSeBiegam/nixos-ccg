{
  pkgs,
  modulesPath,
  ...
}: {
  boot = {
    kernel.sysctl = {
      "vm.nr_hugepages" = 1024;
    };
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
  system.stateVersion = "24.11";
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking = {
    useDHCP = true;
    hostName = "server";
    nameservers = [
      "185.12.64.1"
      "185.12.64.2"
      "2a01:4ff:ff00::add:1"
      "2a01:4ff:ff00::add:2"
    ];
    interfaces.enp1s0.ipv6 = {
      addresses = [
        {
          address = "2a01:4f8:c013:a42a::1";
          prefixLength = 64;
        }
      ];
      routes = [
        {
          address = "fe80::1";
          prefixLength = 64;
        }
        {
          address = "::";
          prefixLength = 0;
          via = "fe80::1";
        }
      ];
    };
  };
}
