{ lib
, stdenv
, lm_sensors
, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "2.0.9"; # Stable
  owner = "Native-Planet";
  rev = "e275f62d712aac0d221e87f170b3ccccaaf2e335";
  repo = "GroundSeg";
  hash = "sha256-jY59ukegprpKu6JKg2E2vwMRFmtC7v0BjsOcKQyKu0A=";

  gosegSrc = fetchFromGitHub {
    inherit owner rev repo hash;
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

  # TODO check if this is the proper way to import sensors
  propegatedBuildInputs = [ lm_sensors ];

  preBuild = ''
    # Copy frontend into web folder, symlink doesn't work
    cp -r ${goseg-ui} ./web

    # Put config in /var/lib instead of /opt
    find . -type f -iname \*.go -exec sed -i 's|/opt/nativeplanet/groundseg|/var/lib/groundseg|g' {} \;

    # HACK: remove noun folder to prevent build errors trying to build it
    # https://github.com/Native-Planet/GroundSeg/issues/591
    rm -r noun
  '';

  vendorHash = "sha256-jfTWlgFGIWc6EwBT0oqfLOXQZnF0wLbJpoXg+bIYI0Y=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
