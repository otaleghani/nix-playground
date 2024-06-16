nix-shell -p git --run "git --version" --pure -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz
# This script grabs a specific version of git. 
# --pure - discarts all environmental variables
# -I is used to specify which version of <nixpkgs> to use, creating a truly reproducible build
