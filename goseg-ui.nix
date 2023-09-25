{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage

# development
, pkgs
}:

buildNpmPackage rec {
  pname = "groundseg-v2-ui";
  version = "unstable-2023-09-24";

  src = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "a8c72589cd6aae5ef155c20c5964b2d9d62a10a1";
    hash = "sha256-sYbI0sPETcmMcfKMapmSEl7Gor+7eJmWd9qUmlhrDJA=";
  } + "/ui";

  npmDepsHash = "sha256-ZY6WtWVJkAm5g8+5lquFW26PYoxST6Y1zqsx42tHjlM=";

  makeCacheWritable = true;

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

# from example, remove?:
# NODE_OPTIONS = "--openssl-legacy-provider";

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
}

