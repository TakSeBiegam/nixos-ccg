{pkgs, ...}: {
  boot.initrd.kernelModules = ["amdgpu"];
  hardware = {
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };
}
