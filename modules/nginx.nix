{
  services.nginx = {
  enable = true;
  virtualHosts."playground.gamescutter.com" = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/playground";
    };
  };
}