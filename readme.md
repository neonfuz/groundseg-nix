# GroundSeg-nix

This is a work in progress nix package for GroundSeg v2 (AKA goseg). GroundSeg
v2 is in heavy development and is not released yet, but packaging v1 is much
more complex and realistically by the time it gets packaged it may be
deprecated. v1 was a python app which has many outdated dependencies in nixpkgs.

As stated above, this is a work in progress. Currently it builds but is untested
and probably needs some patches.

## Building

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
$ goseg
```

## Running on NixOS

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
$ sudo nix run .#goseg
```
