# Installation

## Server

```
nix run github:nix-community/nixos-anywhere -- --flake 'git+ssh://git@dennor.git.sr.ht/~dennor/mydevices#server' nixos@server
```

# Update
## Server

```
$ nixos-rebuild switch --flake '.#server' --target-host root@server
```
