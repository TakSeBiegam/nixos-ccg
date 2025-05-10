{
  lib,
  pkgs,
  ...
}: {
  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };
  fileSystems.server_home_dennor = {
    device = "//10.1.1.2/dennor";
    mountPoint = "/home/dennor/nas_home";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/etc/nas_dennor_home"
      "iocharset=utf8"
      "file_mode=0700"
      "dir_mode=0700"
      "uid=dennor"
      "gid=dennor"
      "nofail"
      "noauto"
      "user"
    ];
  };
}
