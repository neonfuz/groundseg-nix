{
  description = "TODO";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system: with nixpkgsFor.${system}; {
        groundseg = callPackage ./groundseg2.nix { };
      });

      defaultPackage = forAllSystems (system: self.packages.${system}.groundseg);

      defaultApp = forAllSystems (system: {
        type = "app";
        program = "${self.packages.${system}.groundseg}/bin/groundseg";
      });

      devShell = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in pkgs.mkShell {
          buildInputs = with pkgs; [ go gopls goimports go-tools ];
        }
      );
    };
}
