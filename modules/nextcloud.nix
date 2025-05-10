{
  config,
  pkgs,
  ...
}: {
  services = {
    postgresql = {
      ensureDatabases = ["nextcloud"];
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      settings = {
        maintenance_window_start = 3;
        default_phone_region = "PL";
        trusted_proxies = ["10.1.0.1"];
        trusted_domains = ["10.1.0.2"];
      };
      extraAppsEnable = true;
      home = "/data/nextcloud";
      hostName = "nc.xxxxxx.net";
      https = true;
      maxUploadSize = "5G";
      # Required
      notify_push.enable = true;
      config = {
        dbhost = "/run/postgresql";
        dbtype = "pgsql";
        adminpassFile = "/run/secrets/nextcloud/adminpass";
      };
      phpOptions."opcache.interned_strings_buffer" = "23";
      configureRedis = true;
    };
    nginx.virtualHosts."nc.xxxxxx.net" = {
      addSSL = true;
      enableACME = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "user@example.org";
  };
  systemd.services.nextcloud-setup.after = ["postgresql.service"];
  systemd.services.nextcloud-setup.requires = ["postgresql.service"];
  sops.secrets."nextcloud/adminpass" = {
    format = "binary";
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.group;
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
