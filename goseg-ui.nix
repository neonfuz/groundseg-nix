{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage

# development
, pkgs
}:

buildNpmPackage rec {
  pname = "goseg-ui";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Native-Planet";
    repo = "GroundSeg";
    rev = "d12e1f9daee955e8f0d29c58612bf02dbf6cd60a";
    hash = "sha256-A+ONRzkTd25TzvYQICA4XSyaWW45S3JClUF4P3kEAqk=";
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

