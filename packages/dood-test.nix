{pkgs}:
with pkgs;
  rustPlatform.buildRustPackage rec {
    pname = "dood";
    version = "0.1.0";
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    src = fetchgit {
      url = "https://git.sr.ht/~dennor/dood";
      rev = "4cea369c143049aad9201797ee8fdc6f269d3c7d";
      hash = "sha256-CG6RkrWoBx1V6V8NsMWdhUNoR8iPwgrMRcJRXQsT/xg=";
    };
    nativeBuildInputs = [
      pkg-config
      cargo
      rustc
      rustfmt
      rust-analyzer
      clippy
      lldb
      shfmt
    ];
    buildInputs = [
      udev
      alsa-lib
      vulkan-loader
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr # To use the x11 feature
      libxkbcommon
      wayland # To use the wayland feature
    ];
    LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
  }
