{ lib
, stdenv
, lm_sensors
, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "unstable-2023-11-25";
  gosegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "6146c1ab3954b2bf15edfdddb712ad2f816d227d";
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

  propegatedBuildInputs = [ lm_sensors ];

  preBuild = ''
    # Copy frontend into web folder, symlink doesn't work
    cp -r ${goseg-ui} ./web

    # Put config in /var/lib instead of /opt
    find . -type f -iname \*.go -exec sed -i 's|/opt/nativeplanet/groundseg|/var/lib/groundseg|g' {} \;

    # HACKS: These are required to build the current version, but may
    #        cause issues in the future. Try removing these when
    #        upgrading.

    # remove noun folder to prevent build errors trying to build it
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