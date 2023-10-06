# flake.nix
{
  description = "GroundSeg iso experiment";
  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.groundseg.url = "github:neonfuz/groundseg-nix";
  outputs = { self, nixos, groundseg }: {

    nixosConfigurations = let
      # Shared base configuration.
      groundsegLive = {
        system = "x86_64-linux";
        modules = [
          groundseg.nixosModules.groundseg
        ];
      };
    in {
      exampleIso = nixos.lib.nixosSystem {
        inherit (groundsegLive) system;
        modules = groundsegLive.modules ++ [
#          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
        ];
      };
      example = nixos.lib.nixosSystem {
        inherit (groundsegLive) system;
        modules = groundsegLive.modules ++ [
          # Modules for installed systems only.
        ];
      };
    };
  };
}
