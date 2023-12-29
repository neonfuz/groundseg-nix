{ lib
, stdenv
, lm_sensors
, makeWrapper
, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "2.0.12";

  groundsegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "v${version}";
    hash = "sha256-Q+KzOpgmPClgE9ogSHf+W3imGemMA5cGh4SQyI2rfEg=";
  };

  groundseg-ui = buildNpmPackage rec {
    pname = "groundseg-ui";
    inherit version;

    src = groundsegSrc + "/ui";

    npmDepsHash = "sha256-h/fj+jxL1601fPOCSOLW2awOwZsPcH4qFGQgAIlMJZA=";

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

  vendorHash = "sha256-jfTWlgFGIWc6EwBT0oqfLOXQZnF0wLbJpoXg+bIYI0Y=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
