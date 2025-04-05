{
  description = "NixOS installer ISO with GRUB";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      isoImage = pkgs.nixos.isoImage {
        system = "x86_64-linux";
        configuration = { config, pkgs, ... }: {
          # A minimal installer configuration.
          # Additional imports or configuration can be added here.
          imports = [ ];

          # Enable GRUB as the bootloader.
          boot.loader.grub.enable = true;
          boot.loader.grub.device = "nodev";  # Use GRUB without writing to a disk.
          
          # Optionally, disable EFI support if you're targeting legacy systems.
          boot.loader.grub.efiSupport = false;

          # You can add extra services or settings here if needed.
          services.openssh.enable = true;
        };
      };
    });
}
