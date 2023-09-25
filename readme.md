# GroundSeg-nix

This is a work in progress nix package for GroundSeg v2 (AKA goseg). GroundSeg
v2 is not released yet, but packaging v1 is much more complex and realistically
by the time it gets packaged it may be deprecated. v1 was a python app which
has many outdated dependencies in nixpkgs.

This package is a work in progress. There are 2 halves to v2, ui which is a
svelte app, and goseg which is a go app. As of writing the goseg code is mostly
finished in `./groundseg2.nix` file, but it fails to build without the ui.
The next step to packaging should be packaging the ui in nixpkgs, and then
switching focus back to goseg.

## Building

While the code currently does not build, you can run the build by running the
following:

```bash
nix build
```
