{
  config,
  pkgs,
  ...
}: {
  users = {
    groups.naspublic = {};
    users.naspublic = {
      isSystemUser = true;
      group = "naspublic";
    };
  };
  system.activationScripts.sambaHomes.text = ''
    mkdir -p /data/home/dennor
    chown dennor:dennor /data/home/dennor
    chmod 700 /data/home/dennor
  '';
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  services.samba = {
    enable = true;
    settings = {
      global = {
        security = "user";
        workgroup = "WORKGROUP";
        "server string" = "smbnas";
        "netbios name" = "smbna";
        "min protocol" = "smb2";
        "hosts allow" = "10.1.0.0/16  localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      public = {
        path = "/data/public";
        browseable = "yes";
        available = "yes";
        public = "yes";
        writable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0777";
        "directory mask" = "0777";
        "force user" = "naspublic";
        "force group" = "naspublic";
      };
      nfspublic = {
        path = "/data/export";
        browseable = "yes";
        available = "yes";
        public = "yes";
        writable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0777";
        "directory mask" = "0777";
        "force user" = "naspublic";
        "force group" = "naspublic";
      };
      homes = {
        browseable = "no";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0755";
        "directory mask" = "0755";
        "valid users" = "%S";
        path = "/data/home/%S";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [445 139];
  networking.firewall.allowedUDPPorts = [137 138];
}
