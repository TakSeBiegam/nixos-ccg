{
  pkgs,
  config,
  ...
}: let
  virtual-camera = pkgs.writeShellScriptBin "virtual-camera.sh" ''
    sudo rmmod v4l2loopback
    sudo modprobe v4l2loopback card_label="Virtual Camera" video_nr=0
    ${pkgs.gphoto2}/bin/gphoto2 --stdout --set-config liveviewsize=0  --set-config viewfindersize=1 --wait-event=1s  --capture-movie | ${pkgs.ffmpeg}/bin/ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 4 -f v4l2 ''${1:-/dev/video0}
  '';
in {
  boot = {
    kernelModules = ["v4l2loopback" "snd-aloop"];
    extraModprobeConfig = ''
      # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
      # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
      # https://github.com/umlaeute/v4l2loopback
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
    extraModulePackages = with pkgs; [config.boot.kernelPackages.v4l2loopback];
  };
  environment.systemPackages = with pkgs; [v4l-utils virtual-camera];
}
