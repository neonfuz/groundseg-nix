# GroundSeg-nix

<img align="right" width="150" src="https://nyc3.digitaloceanspaces.com/neonfuz-ur/tabbyr-firwen/2023.9.15..19.20.05-groundseg-nix.png" />

This is a work in progress nix package for GroundSeg v2 (AKA goseg). GroundSeg
v2 is still in development and not released yet, so expect bugs.

## Caveats

 - uses docker 24, may be incompatible with older versions and or podman with docker-compat (see https://github.com/Native-Planet/GroundSeg/issues/624)
 - runs groundseg as root (see https://github.com/Native-Planet/GroundSeg/issues/589)
 - disables firewall (see https://github.com/neonfuz/groundseg-nix/issues/1)

## Installation (flake + module)

Until it's merged into nixpkgs, this module is distributed as a flake. In order
to install the systemd service you need to enable flakes on your. For info on
enabling flakes on nixos go
[here](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled)

flake.nix:
```nix
{
  # Import groundseg flake:
  inputs.groundseg.url = "github:neonfuz/groundseg-nix";

  nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
    ...
    modules = [
      ./configuration.nix
      # Add the module to your system modules
      groundseg.nixosModules.groundseg
    ];
  };
}
```

```nix
{
  # Enable the groundseg service
  services.groundseg.enable = true;
}
```

## Unfiled upstream groundseg bugs / feature requests

### Nix related feature requests

 - declarative: allow setting password from config
 - declarative: allow configuring startram from config
 - declarative: allow booting and importing ships from config

### Bugs to retest before filing

 - penpai doesn't work through startram

### Elusive bugs

 - doing actions after session expired
