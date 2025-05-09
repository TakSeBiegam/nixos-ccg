{
  services.nextdns = {
    arguments = [
      "-listen"
      "0.0.0.0:53"
      "-cache-size=10MB"
      "-cache-max-age=1h"
      "-config-file"
      "/run/secrets/nextdns/config"
    ];
    enable = true;
  };
  networking.firewall.allowedUDPPorts = [53];
  networking.firewall.allowedTCPPorts = [53];
  sops.secrets."nextdns/config" = {
    format = "binary";
  };
}
