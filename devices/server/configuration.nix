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
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJzEHgtTLEJzBK0LcWbQn1UGyAN1iy1gzaojfZrDCsdL3Z3Dc09GeW/j3MTLnA19t4OI7sNmhlk/K8SuiXD0wo816g3Y0bpq3/iywp6ZRCgZ7gaTmcjvWOqgadp8/glhB4ilmKEWAWycVrM+Hx+qzKdWj9B4SzDwcthZn2rPALKU9haqWexmZKOfltpPgynSdeK6Bd/5WqKoegBDpJArzqbVhEpfCLA0+eQyaHJiZ8BtfSgVWgXkrOPRYcoh+rUj3mqmBOdHtueZzps7+2mVYPth5JzZx/PK9hNA1gHgEDyA3zFJnswyG2bC8iXmJFCog2nPHdizl3IIR/7WQSiStr+DVjByVCcceKOItewNr+zfkHRQj4JmFK2vhD/D3N8kdZ1n91b+XPaFBeusUN9ZrbDEGi+LAg/EM9V4xhmjq0rVSZCDQM6abINy7cgkhA4pHOepM/SQZCLD6PDM1hfJIaJgS8rMYlDup6HkwNysIcYGQKzYlJzaZgz1EreZB7EWs="
  ];
  system.stateVersion = "24.11";
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
  time.timeZone = "Europe/Warsaw";
}
