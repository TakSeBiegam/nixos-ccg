{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;

    virtualHosts."playground.gamescutter.com" = {
      enableACME = true;
      forceSSL = true;

      locations."/graphql" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@gamescutter.com";
  };
}