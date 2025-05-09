args @ {inputs, ...}: {
  imports = [inputs.process-compose-flake.flakeModule];
  flake.processComposeModules.default = import ../services args;
  perSystem = {
    process-compose."default" = {config, ...}: {
      imports = [
        inputs.services-flake.processComposeModules.default
        inputs.self.processComposeModules.default
      ];
    };
  };
}
