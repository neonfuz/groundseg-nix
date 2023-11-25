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

## Installation (nix-env)

For convenience after building you can install it into your nix-env:

```bash
# install
$ nix-env -i ./result
# usage
$ sudo goseg
```

## Running nix-env build on NixOS

If you use the flake and module as outlined in the "Installation (flake + module)"
these options will be enabled for you and you don't need to do anything else.

Make sure you have network manager and docker 24 enabled, and that your firewall
is configured to allow the appropriate traffic in your system config:

```nix
{
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_24;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
}
```

run groundseg:

```bash
$ cd groundseg-nix
$ sudo nix run .#groundseg
```
