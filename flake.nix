{
  description = "The best way to run an Urbit ship";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-compat, ... }:
    let
      # TODO test "x86_64-darwin" "aarch64-linux" "aarch64-darwin"
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      nixosModules.groundseg = import ./module.nix self;
      packages = forAllSystems (system: with nixpkgsFor.${system}; rec {
        groundseg = callPackage ./groundseg.nix { };
      });

      defaultPackage = forAllSystems (system: self.packages.${system}.groundseg);

      defaultApp = forAllSystems (system: {
        type = "app";
        program = "${self.packages.${system}.groundseg}/bin/goseg";
      });
    };
}
