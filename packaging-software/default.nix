let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  # callPackage will supply automatically every needed attribute in the declaration set
  hello = pkgs.callPackage ./hello.nix { };
}
