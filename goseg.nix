{ lib
, stdenv

# development
, pkgs

, groundseg-ui

, buildGo121Module
, fetchFromGitHub
}:

buildGo121Module rec {
  pname = "groundseg-v2";
  version = "unstable-2023-09-24";

  src = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "a8c72589cd6aae5ef155c20c5964b2d9d62a10a1";
    hash = "sha256-sYbI0sPETcmMcfKMapmSEl7Gor+7eJmWd9qUmlhrDJA=";
  } + "/goseg";

  preBuild = ''
    cp -r ${groundseg-ui} ./web
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
