{
  perSystem = args @ {
    config,
    pkgs,
    ...
  }: {
    # export the project devshell as the default devshell
    devShells = import ../shells/rust args;

    packages = {
      # Slightly hackish, but at this point in time, it's impossible to override
      # helix languages.toml in any form which makes it very hard to acutally
      # create a preconfigured helix shell. This should no longer be necessary
      # when helix team finishes the planned overhaul of config system.
      # Tracking issue: https://github.com/helix-editor/helix/issues/10389
      # For now you can just set the contents of .envrc to:
      #  source "$(nix build flake#helix --print-out-paths --no-link)/bin/envrc"
      helix = let
        config = (pkgs.formats.toml {}).generate "config.toml" {};
        languages = (pkgs.formats.toml {}).generate "languages.toml" {
          language-server.rust-analyzer.config.check = {
            command = "clippy";
            extraArgs = ["--" "-W" "clippy::pedantic"];
          };
          language = [
            {
              auto-format = true;
              name = "bash";
              formatter = {
                command = "shfmt";
              };
            }
            {
              auto-format = true;
              name = "nix";
              formatter = {
                command = "alejandra";
              };
            }
            {
              auto-format = true;
              name = "markdown";
            }
            {
              auto-format = true;
              name = "rust";
              formatter = {
                command = "rustfmt";
              };
            }
            {
              auto-format = true;
              name = "toml";
              formatter = {
                command = "toml-sort";
              };
            }
          ];
        };
      in
        pkgs.writeShellScriptBin "envrc" ''
          rm -r .helix
          mkdir -p .helix
          ln -s ${config} .helix/config.toml
          ln -s ${languages} .helix/languages.toml
          watch_file nix/**
          watch_file -- **/*.nix
          use flake .#helix
        '';
    };
  };
}
