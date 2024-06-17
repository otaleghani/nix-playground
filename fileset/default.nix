{
  system ? builtins.currentSystem,
  # sources ? import ./nix/sources.nix,
}:
let
  # pkgs = import sources.nixpkgs {
  pkgs = import <nixpkgs> {
    config = { };
    overlays = [ ];
    inherit system;
  };
in
pkgs.callPackage ./build.nix { }
