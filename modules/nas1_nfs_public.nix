{
  lib,
  pkgs,
  ...
}: {
  security.wrappers."mount.nfs" = {
    program = "mount.nfs";
    source = "${lib.getBin pkgs.nfs-utils}/bin/mount.nfs";
    owner = "root";
    group = "root";
    setuid = true;
  };
  fileSystems.server_nfs_public = {
    device = "10.1.1.2:/data/export";
    mountPoint = "/home/user/nas_public";
    fsType = "nfs";
    options = [
      "nofail"
      "noauto"
      "user"
    ];
  };
}
