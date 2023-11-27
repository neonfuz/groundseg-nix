{ lib
, stdenv
, lm_sensors
, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "2.0.1-1";
  gosegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "v${version}";
    #hash = lib.fakeHash;
    hash = "sha256-4VWguVmN1TBwdx3Moqf6f9C7tHKbGYjS4c5OM/Swhv8=";
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
    rm -r noun
  '';

  vendorHash = "sha256-YrMs08zQkSUZRkiMFSD9jCxktDOmT+KogahTBRyzv+U=";

  meta = with lib; {
    description = "The best way to run an Urbit ship";
    homepage = "https://github.com/Native-Planet/GroundSeg";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
