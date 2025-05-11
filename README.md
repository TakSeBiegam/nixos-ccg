# Installation

## Locally (client -> server)

```
nix run github:nix-community/nixos-anywhere -- --flake '.#server' nixos@server
```

## Update (client -> server)

```
$ nixos-rebuild switch --flake '.#server' --target-host root@server
```
> [!NOTE]
> root@server mean connect to machine via ssh where "server" stands for dns in ~/.ssh/config 


## Update (server -> server)

```
$ nixos-rebuild switch --flake 'github:TakSeBiegam/nixos-ccg#server'
```
> [!NOTE]
> Make sure if you trigger that command, you pushed everything on your repository