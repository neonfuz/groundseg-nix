{ lib
, stdenv

# development
, pkgs

, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "unstable-2023-09-25";
  gosegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "d12e1f9daee955e8f0d29c58612bf02dbf6cd60a";
    hash = "sha256-A+ONRzkTd25TzvYQICA4XSyaWW45S3JClUF4P3kEAqk=";
  };
  goseg-ui = buildNpmPackage rec {
    pname = "goseg-ui";
    inherit version;

    src = gosegSrc + "/ui";

    npmDepsHash = "sha256-ZY6WtWVJkAm5g8+5lquFW26PYoxST6Y1zqsx42tHjlM=";

    makeCacheWritable = true;

    installPhase = ''
      runHook preInstall
      cp -a build $out
      runHook postInstall
    '';

    meta = with lib; {
      description = "The best way to run an Urbit ship";
      homepage = "https://github.com/Native-Planet/GroundSeg";
      license = licenses.mit;
      maintainers = with maintainers; [ neonfuz ];
    };
  };
in
buildGo121Module rec {
  pname = "goseg";
  inherit version;

  src = gosegSrc + "/goseg";

  preBuild = ''
    cp -r ${goseg-ui} ./web

    # HACKS: on each update, try removing each of these and
    #        remove them if it builds without it

    # remove fmt import to fix error
    sed -i /fmt/d noun/noun.go
  '';

  vendorHash = "sha256-Ok8ObEtie61HasVbvUH3TodouMsJXCuL2cBULsqfhVQ=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
