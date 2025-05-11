{ pkgs, ... }:

let
  repoUrl = "git@github.com:TakSeBiegam/foundation-playing-bialystok-backend.git";
  projectPath = "/apps/foundation-playing-bialystok/api";
in
{
  users.users.apiuser = {
    isNormalUser = true;
    home = "/home/apiuser";
    group = "users";
  };

  systemd.services.clone-playground-api = {
    description = "Clone API repo";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "apiuser";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${projectPath}";
      ExecStart = "${pkgs.git}/bin/git clone --depth=1 ${repoUrl} ${projectPath}";
    };
  };

  systemd.services.playground-api = {
    description = "Run Playground API";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "clone-playground-api.service" ];
    serviceConfig = {
      WorkingDirectory = projectPath;
      ExecStart = "${pkgs.nodejs}/bin/node index.js";
      Restart = "always";
      User = "apiuser";
    };
  };
}
