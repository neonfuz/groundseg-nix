{ lib
, stdenv

# development
, pkgs

, goseg-ui

, buildGo121Module
, fetchFromGitHub
}:

buildGo121Module rec {
  pname = "goseg";
  version = "unstable-2023-09-25";

  src = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "d20938a881df5ff393685220e7d7edb97d04d909";
    hash = "sha256-A+ONRzkTd25TzvYQICA4XSyaWW45S3JClUF4P3kEAqk=";
  } + "/goseg";

  preBuild = ''
    cp -r ${goseg-ui} ./web

    # HACKS: on each update, try removing each of these and
    #        remove them if it builds without it
    # remove fmt import to fix error
    sed -i /fmt/d noun/noun.go
    #sed -i /delJSON/d startram/startram.go
  '';

  vendorHash = "sha256-Ok8ObEtie61HasVbvUH3TodouMsJXCuL2cBULsqfhVQ=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
