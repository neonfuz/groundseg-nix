{ lib
, stdenv
, lm_sensors
, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "2.0.12";

  gosegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "v${version}";
    hash = "sha256-Q+KzOpgmPClgE9ogSHf+W3imGemMA5cGh4SQyI2rfEg=";
  };

  goseg-ui = buildNpmPackage rec {
    pname = "goseg-ui";
    inherit version;

    src = gosegSrc + "/ui";

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
  pname = "goseg";
  inherit version;

  src = gosegSrc + "/goseg";

  buildInputs = [ lm_sensors ];

  preBuild = ''
    # Copy frontend into web folder, symlink doesn't work
    cp -r ${goseg-ui} ./web

    # Put config in /var/lib instead of /opt
    find . -type f -iname \*.go -exec sed -i 's|/opt/nativeplanet/groundseg|/var/lib/groundseg|g' {} \;
  '';

  vendorHash = "sha256-jfTWlgFGIWc6EwBT0oqfLOXQZnF0wLbJpoXg+bIYI0Y=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
