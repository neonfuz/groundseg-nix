# GroundSeg-nix

<img align="right" width="150" src="https://nyc3.digitaloceanspaces.com/neonfuz-ur/tabbyr-firwen/2023.9.15..19.20.05-groundseg-nix.png" />

A flake for installing GroundSeg on NixOS.

## Installation (flake + module)

Enabling the flake will install GroundSeg as a service, as well as all of it's dependencies.
The most significant dependency is docker 24. GroundSeg requires docker 24+, so it may fail
to install if you have manually enabled a lower version or podman with docker-compat.

If you have not yet done so, configure your NixOS to use flakes. To do this, follow
`Enabling Flakes Support` and `Switching to flake.nix for System Configuration`
[HERE](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled).

After enabling flakes, modify `flake.nix` and `configuration.nix` to add the following lines.
The lines you need to add are the lines following comments:

flake.nix:
```nix
{
  inputs = {
    ...
    # Import the groundseg flake
    groundseg.url = "github:neonfuz/groundseg-nix";
  };

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

configuration.nix:
```nix
{
  # Enable the groundseg service
  services.groundseg.enable = true;
}
```

## Caveats

 - uses docker 24, may be incompatible with different versions and or podman+docker-compat (see https://github.com/Native-Planet/GroundSeg/issues/624)
 - runs groundseg as root (see https://github.com/Native-Planet/GroundSeg/issues/589)
 - disables firewall (see https://github.com/neonfuz/groundseg-nix/issues/1)

## Unfiled GroundSeg bugs and feature requests

### Nix related feature requests

 - declarative: allow setting password from config
 - declarative: allow configuring startram from config
 - declarative: allow booting and importing ships from config

### Bugs to retest before filing

 - penpai doesn't work through startram

### Elusive bugs

 - doing actions after session expired
