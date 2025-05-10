{ lib
, stdenv
, lm_sensors
, makeWrapper
, fetchFromGitHub
, buildNpmPackage
, buildGo123Module
}:

let
  version = "2.4.7";

  groundsegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "81c0bfcf56675f9f2968d4f65463e043abf08a37";
    hash = "sha256-h0EHijO0E/VMNJFLj4VKM8t+b/qbGzJ2yIYT91MJoHU=";
  };

  groundseg-ui = buildNpmPackage rec {
    pname = "groundseg-ui";
    inherit version;

    src = groundsegSrc + "/ui";

    npmDepsHash = "sha256-QSKy5PwHG0YbeDnm90zVDPH1fiAYqXg0+I0sEkevGAk=";

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
buildGo123Module rec {
  pname = "groundseg";
  inherit version;

  src = groundsegSrc + "/goseg";

  buildInputs = [ lm_sensors makeWrapper ]; # lsblk

  # Copy frontend into web folder:
  # Symlink doesn't work, see: https://github.com/golang/go/issues/44507
  preBuild = "cp -r ${groundseg-ui} ./web";

  # Use /var/lib/groundseg instead of /opt/nativeplanet/groundseg:
  postInstall = ''
    wrapProgram "$out/bin/groundseg" --set GS_BASE_PATH /var/lib/groundseg
  '';

  vendorHash = "sha256-iuqM+1u37BAm5lnpr15FVc+rJFzIMmfJPeVkU1S4P2U=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
