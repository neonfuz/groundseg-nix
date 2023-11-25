# GroundSeg-nix

<img align="right" width="150" src="https://nyc3.digitaloceanspaces.com/neonfuz-ur/tabbyr-firwen/2023.9.15..19.20.05-groundseg-nix.png" />

This is a work in progress nix package for GroundSeg v2 (AKA goseg). GroundSeg
v2 is still in development and not released yet, so expect bugs.

## Installation (flake + module)

Until it's merged into nixpkgs, this module is distributed as a flake. In order
to install the systemd service you need to enable flakes on your. For info on
enabling flakes on nixos go
[here](https://nixos.wiki/wiki/Flakes#Enable_flakes_permanently_in_NixOS)

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

## Building

You can also build the groundseg package without the systemd service for testing

### Flakes (recommended):

```bash
$ nix build
```

### Non-flakes (compat layer):

```bash
$ nix-build
```

## Known bugs

Last tested 2023-11-25

 - netdata apps plugin uses tons of cpu
 - does not run as non root user
 - spaces in path name make disk usage detection fail
 - noun folder existence makes build fail (has main entrypoint?)
 - minio does not get set up in ships
 - penpai shows 1 less core than the machine has (is this intentional?)

## Feature requests

These are features that I think groundseg v2 should implement

 - ships dashboard: on/off toggle
 - ships dashboard: sorting options
 - system tab disk usage: show disk labels instead of disk path
 - booting ships: populate ship names from key filename
 - booting ships: allow booting in parallel (/boot/new/sampel-palnet)
 - penpai: ability to read data from ships
 - declarative: allow setting password from config
 - declarative: allow configuring startram from config
 - declarative: allow booting and importing ships from config

