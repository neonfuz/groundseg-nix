{ lib
, stdenv
, lm_sensors
, makeWrapper
, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "2.2.1";

  groundsegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "ce3e18b7e8ef32214736a36279b146f6b5dce974";
    hash = "sha256-r5c6jHjqRhY52oRjesG5N03wxAjrvcSValUamXnLnRU=";
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
buildGo121Module rec {
  pname = "groundseg";
  inherit version;

  src = groundsegSrc + "/goseg";

  buildInputs = [ lm_sensors makeWrapper ];

  # Copy frontend into web folder:
  # Symlink doesn't work, see: https://github.com/golang/go/issues/44507
  preBuild = "cp -r ${groundseg-ui} ./web";

  # Use /var/lib/groundseg instead of /opt/nativeplanet/groundseg:
  postInstall = ''
    wrapProgram "$out/bin/groundseg" --set GS_BASE_PATH /var/lib/groundseg
  '';

  vendorHash = "sha256-hMYXmrFe9KJoXrUd6hhgLmUE2CDvrcY+rkdYfHtEfLY=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
