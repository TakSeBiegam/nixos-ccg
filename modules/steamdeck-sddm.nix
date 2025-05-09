{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs.kdePackages; [
    # Basic packages without which Plasma Mobile fails to work properly.
    plasma-mobile
    plasma-nano
    pkgs.maliit-framework
    pkgs.maliit-keyboard
    # Additional software made for Plasma Mobile.
    alligator
    angelfish
    audiotube
    calindori
    kalk
    kasts
    kclock
    keysmith
    koko
    krecorder
    ktrip
    kweather
    spacebar
  ];
  services = {
    xserver.desktopManager.plasma5 = {
      kdeglobals = {
        KDE = {
          # This forces a numeric PIN for the lockscreen, which is the
          # recommendation from upstream.
          LookAndFeelPackage = lib.mkDefault "org.kde.plasma.phone";
        };
      };
      kwinrc = {
        "Wayland" = {
          "InputMethod[$e]" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
          "VirtualKeyboardEnabled" = "true";
        };
        "org.kde.kdecoration2" = {
          # No decorations (title bar)
          NoPlugin = lib.mkDefault "true";
        };
      };
    };
    desktopManager.plasma6.enable = true;
    displayManager = {
      enable = true;
      defaultSession = "steamdeck";
      autoLogin = {
        enable = true;
        user = "dennor";
      };
      sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
          compositorCommand = "${lib.getBin pkgs.kdePackages.kwin}/bin/kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1 --inputmethod ${lib.getBin pkgs.maliit-keyboard}/bin/maliit-keyboard";
        };
        extraPackages = [pkgs.maliit-keyboard];
        autoLogin.relogin = true;
      };
      sessionPackages = let
        steam-session = pkgs.writeShellScriptBin "steam-session" ''
          session=gamescope
          if [ -f $XDG_RUNTIME_DIR/sessions-swap ]; then
            session="$(cat $XDG_RUNTIME_DIR/sessions-swap)"
            rm -rf $XDG_RUNTIME_DIR/sessions-swap
          fi
          case "$session" in
            "plasma")
              ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${pkgs.kdePackages.plasma-mobile}/bin/startplasmamobile ;;
            *)
              gamescope --adaptive-sync --hdr-enabled --rt --steam -- steam -tenfoot -pipewire-dmabuf -steamdeck -steamos3 ;;
          esac
        '';

        gamescopeSessionFile =
          (pkgs.writeTextDir "share/wayland-sessions/steamdeck.desktop" ''
            [Desktop Entry]
            Name=SteamDeck
            Comment=A digital distribution platform
            Exec=${steam-session}/bin/steam-session
            Type=Application
          '')
          .overrideAttrs (_: {passthru.providedSessions = ["steamdeck"];});
      in [gamescopeSessionFile];
    };
  };
  programs.steam.package = pkgs.steam.override {
    extraLibraries = pkgs: [pkgs.xorg.libxcb];
    extraPkgs = pkgs:
      with pkgs; let
        sessionSwitcher = pkgs.writeShellScriptBin "steamos-session-select" ''
          echo -n "plasma" > $XDG_RUNTIME_DIR/sessions-swap
          steam -shutdown
        '';
      in [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamemode
        sessionSwitcher
        jovian-stubs
      ];
  };
  xdg.portal.config = {
    gamescope = {
      default = ["none"];
    };
  };
  users.users.dennor.hashedPassword = lib.mkForce "$y$j9T$hiqCIx8T3kE0COFzJKo1w1$JSar6xXxhQ8Tgh2WGt69lf.GrQa/ibjRNb91bW5bR.6";
}
