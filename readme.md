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

## Filed bugs

 - does not run as non root user
 - spaces in path name make disk usage detection fail
 - noun folder existence makes build fail (has main entrypoint?)
 - penpai shows 1 less core than the machine has (is this intentional?)
 - feature request: run single minio server
 - minio does not get set up in ships
 - booting ship set to remote with lapsed subscription breaks ship and settings page
 - booting ships: populate ship names from key filename
 - ships dashboard: ability to sort by boot date
 - ships dashboard: on/off toggle
 - system tab disk usage: show disk labels instead of disk path
 - docker: stop containers when stopping groundseg service
 - penpai: ability to read data from ships
 - booting ships UX: allow booting in parallel (/boot/new/sampel-palnet)
 - netdata apps plugin uses tons of cpu
 - minio containers don't get deleted on ship delete
 - lapsed startram subscriptions don't send out email


## Nix related feature requests (unfiled)

 - docker: support podman
 - declarative: allow setting password from config
 - declarative: allow configuring startram from config
 - declarative: allow booting and importing ships from config

## Bugs to retest (unfiled)

 - penpai doesn't work through startram (working at all?)

## Elusive bugs (unfiled)

 - booting ship after session expired flow
