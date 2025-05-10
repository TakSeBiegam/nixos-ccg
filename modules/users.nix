{pkgs, ...}: {
  programs.zsh.enable = true;
  nix.settings.trusted-users = ["@wheel"];
  users = {
    mutableUsers = false;
    groups = {
      arek = {};
    };
    users = {
      root.hashedPassword = "$6$XDm5SzXP1efyT63S$p8LfTple/zte.d0AiKSSn.91.3Y3ZjTYYnjfrWQu0DwJVSxC06wMr99jweUzqdjEmDiJkEQgJFI04okPmwOv4.";

      arek = {
        isNormalUser = true;
        group = "arek";
        home = "/home/arek";
        description = "Arkadiusz Kurylo User";
        extraGroups = ["wheel" "networkmanager" "input"];
        createHome = true;
        hashedPassword = "$6$XDm5SzXP1efyT63S$p8LfTple/zte.d0AiKSSn.91.3Y3ZjTYYnjfrWQu0DwJVSxC06wMr99jweUzqdjEmDiJkEQgJFI04okPmwOv4.";
        openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJzEHgtTLEJzBK0LcWbQn1UGyAN1iy1gzaojfZrDCsdL3Z3Dc09GeW/j3MTLnA19t4OI7sNmhlk/K8SuiXD0wo816g3Y0bpq3/iywp6ZRCgZ7gaTmcjvWOqgadp8/glhB4ilmKEWAWycVrM+Hx+qzKdWj9B4SzDwcthZn2rPALKU9haqWexmZKOfltpPgynSdeK6Bd/5WqKoegBDpJArzqbVhEpfCLA0+eQyaHJiZ8BtfSgVWgXkrOPRYcoh+rUj3mqmBOdHtueZzps7+2mVYPth5JzZx/PK9hNA1gHgEDyA3zFJnswyG2bC8iXmJFCog2nPHdizl3IIR/7WQSiStr+DVjByVCcceKOItewNr+zfkHRQj4JmFK2vhD/D3N8kdZ1n91b+XPaFBeusUN9ZrbDEGi+LAg/EM9V4xhmjq0rVSZCDQM6abINy7cgkhA4pHOepM/SQZCLD6PDM1hfJIaJgS8rMYlDup6HkwNysIcYGQKzYlJzaZgz1EreZB7EWs= kurylo.ao@gmail.com"];
        autoSubUidGidRange = true;
        shell = pkgs.zsh;
      };
    };
  };
}
