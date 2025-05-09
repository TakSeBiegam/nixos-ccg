{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = ["postgres"];
    package = pkgs.postgresql_16;
    ensureUsers = [
      {
        name = "postgres";
        ensureDBOwnership = true;
      }
    ];
  };
}
