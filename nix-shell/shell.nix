# This is a nix shell
# A file called shell.nix that you can access by calling nix-shell in the directory this file is in.
# In this file we are fetching a specif nixpkgs version from github, then we override it's configuration and overlays because it could have some set and then we call mkShell (make shell) NoCC (no C compiler) with the packages lolcat and cowsay

let 
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    lolcat
    cowsay
  ];

  GREETING = "Hello, Nix"; # this is an env variable that will be exported in this shell
  # Every var that is not protected / reserved will be treated like an env var.
  TEST = 3;

  # shellHook runs the script before the shell becomes interactive
  shellHook = ''
    echo $GREETING, $TEST | cowsay | lolcat
  '';
}
