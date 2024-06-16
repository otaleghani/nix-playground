let
  pkgs = import <nixpkgs> { };
in
rec {
  hello = pkgs.callPackage ./hello.nix { audience = "sandro"; };
  hello-alberto = hello.override { audience = "alberto"; };
}
