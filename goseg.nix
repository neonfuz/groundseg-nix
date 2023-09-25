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
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "13b55914eb1f5d244ce9a73eeae97c8900a799b1";
    hash = "sha256-h7dCRjg0LWKE4w4G+ODRfbqp+G07MPoaErN3efpYpSM=";
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
