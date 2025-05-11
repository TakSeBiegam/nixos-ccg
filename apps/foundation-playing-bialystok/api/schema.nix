{ pkgs, ... }:

let
  
  repoUrl = "https://github.com/TakSeBiegam/foundation-playing-bialystok-backend.git";
  projectPath = "/home/apiuser/apps/foundation-playing-bialystok/api";
in
{
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
    environment = {
      PATH = "${pkgs.bash}/bin:${pkgs.coreutils}/bin:${pkgs.nodejs}/bin";
    };
    serviceConfig = {
      WorkingDirectory = projectPath;
      ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.nodejs}/bin/npm install && ${pkgs.nodejs}/bin/npm run build'";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.nodejs}/bin/npm run start'";
      Restart = "always";
      User = "apiuser";
    };
  };
}
