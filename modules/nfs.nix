{configs, ...}: {
  services.nfs.server = {
    enable = true;
    exports = ''
      /data/export 10.1.0.0/16(rw,sync)
    '';
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
  };
  networking.firewall.allowedTCPPorts = [111 2049 4000 4001 4002 20048];
  networking.firewall.allowedUDPPorts = [111 2049 4000 4001 4002 20048];
}
