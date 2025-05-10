{
  lib,
  pkgs,
  config,
  ...
}: let
  # Is there a better, less explicit way to use the same uid and gid
  # in both host and container?
  rtorrent = {
    uid = 888;
    gid = 888;
  };
in {
  users = {
    groups.rtorrent.gid = rtorrent.gid;
    users.rtorrent = {
      isSystemUser = true;
      uid = rtorrent.uid;
      group = "rtorrent";
    };
  };
  system.activationScripts.sambaHomes.text = ''
    mkdir -p /persist/etc/mullvad-vpn /persist/var/log/mullvad-vpn /persist/var/cache/mullvad-vpn
    mkdir -p /run/rtorrent /var/lib/rtorrent /var/lib/flood
    chown -R rtorrent:rtorrent /var/lib/flood /run/rtorrent /persist/var/lib/rtorrent
  '';
  # skim this blog post:
  # https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-rtorrent"];

  # change this to your actual network interface (run ifconfig or ip a)
  networking.nat.externalInterface = "enp4s0";

  # critical fix for mullvad-daemon to run in container, otherwise errors with: "EPERM: Operation not permitted"
  # It seems net_cls API filesystem is deprecated as it's part of cgroup v1. So it's not available by default on hosts using cgroup v2.
  # https://github.com/mullvad/mullvadvpn-app/issues/5408#issuecomment-1805189128
  fileSystems."/tmp/net_cls" = {
    device = "net_cls";
    fsType = "cgroup";
    options = ["net_cls"];
  };

  containers.rtorrent = {
    ephemeral = true;
    autoStart = true;
    privateNetwork = true;

    # these IP choices are arbitrary, copied from https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
    hostAddress = "192.168.100.2";
    localAddress = "192.168.100.11";

    bindMounts = {
      "/etc/mullvad-vpn" = {
        hostPath = "/persist/etc/mullvad-vpn";
        isReadOnly = false;
      };
      "/var/cache/mullvad-vpn" = {
        hostPath = "/persist/var/cache/mullvad-vpn";
        isReadOnly = false;
      };
      "/var/log/mullvad-vpn" = {
        hostPath = "/persist/var/log/mullvad-vpn";
        isReadOnly = false;
      };
      "/run/secrets/mullvad/account" = {
        hostPath = "/run/secrets/mullvad/account";
        isReadOnly = true;
      };
      "/run/rtorrent" = {
        hostPath = "/run/rtorrent";
        isReadOnly = false;
      };
      "/var/lib/rtorrent" = {
        hostPath = "/var/lib/rtorrent";
        isReadOnly = false;
      };
      "/var/lib/rtorrent/download" = {
        hostPath = "/data/export/downloads";
        isReadOnly = false;
      };
    };

    config = {
      pkgs,
      lib,
      ...
    }: {
      system.stateVersion = "24.05";
      # apparently need this for DNS to work
      networking.useHostResolvConf = false;
      services.resolved.enable = true;

      services.openssh.enable = true;

      users = {
        groups.rtorrent.gid = rtorrent.gid;
        users = {
          root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 XXXX root@nixos"
          ];
          rtorrent = {
            isSystemUser = true;
            uid = rtorrent.uid;
            group = "rtorrent";
          };
        };
      };

      services.mullvad-vpn.enable = true;
      # each mullvad account login will generate a new "device" (wireguard key)
      # and you're limited to 5 devices per account
      # go to https://mullvad.net/en/account/devices to clear out old devices
      systemd.services."mullvad-daemon".postStart = ''
        while ! ${pkgs.mullvad}/bin/mullvad status >/dev/null; do sleep 1; done

        # REPLACE with your actual mullvad account number
        account="$(cat /run/secrets/mullvad/account)"

        # only login if we're not already logged in otherwise we'll get a new device
        current_account="$(${pkgs.mullvad}/bin/mullvad account get | grep "account:" | sed 's/.* //')"
        if [[ "$current_account" != "$account" ]]; then
          ${pkgs.mullvad}/bin/mullvad account login "$account"
        fi

        ${pkgs.mullvad}/bin/mullvad lan set allow
        ${pkgs.mullvad}/bin/mullvad relay set location pl waw
        ${pkgs.mullvad}/bin/mullvad lockdown-mode set on
        ${pkgs.mullvad}/bin/mullvad auto-connect set on

        # disconnect/reconnect is dirty hack to fix mullvad-daemon not reconnecting after a suspend
        ${pkgs.mullvad}/bin/mullvad disconnect
        sleep 0.1
        ${pkgs.mullvad}/bin/mullvad connect
      '';
      services.rtorrent = {
        enable = true;
        dataPermissions = "0754";
        configText = ''
          system.umask.set = 0023
        '';
      };
    };
  };
  systemd.services.flood = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "Flood service for rtorrent";
    script = ''
      ${pkgs.flood}/bin/flood --rtsocket /run/rtorrent/rpc.sock -d /var/lib/flood
    '';
    serviceConfig = {
      User = "rtorrent";
      Group = "rtorrent";
      Type = "simple";
      KillMode = "process";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
  services.nginx = {
    upstreams.flood = {
      servers."127.0.0.1:3000" = {};
    };
    virtualHosts."flood.xxx.net" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;
      locations."/" = {
        proxyPass = "http://flood";
        proxyWebsockets = true;
      };
    };
    virtualHosts."flood.local".locations."/" = {
      proxyPass = "http://flood";
      proxyWebsockets = true;
    };
  };

  sops.secrets."mullvad/account" = {
    format = "binary";
  };
}
