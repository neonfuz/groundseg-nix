{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, buildGo121Module
}:

let
  version = "unstable-2023-10-06";
  gosegSrc = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "d8f578acdcaca6c69781415ba4fabf942d1ce462";
    hash = "sha256-9Ecyelepp3w7JCMZquAt1KZ8SfjEw2e6ZipC4rb+DSU=";
  };
  goseg-ui = buildNpmPackage rec {
    pname = "goseg-ui";
    inherit version;

    src = gosegSrc + "/ui";

    npmDepsHash = "sha256-DEHRrVU/sYiodUO9HxxQKJqnK7n2RV9elxjU++ZEr6U=";

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
