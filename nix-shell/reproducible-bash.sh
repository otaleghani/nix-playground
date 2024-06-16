#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

curl https://github.com/NixOS/nixpkgs/releases.atom | xml2json | jq .

# shebang that calls env to use nix-shell as an interpreter
# this gives us the ability to define a couple of things
# -i : which program should interprete this script
# -p : packages to use
# -I : declare the nixpkgs version
