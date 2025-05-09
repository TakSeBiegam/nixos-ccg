{pkgs, ...}: {
  environment.systemPackages = [pkgs.cifs-utils];
}
