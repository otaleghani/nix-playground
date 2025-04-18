
{
  description = "Custom NixOS ISO installer with GRUB";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;

        nixosSystem = lib.nixosSystem {
          inherit system;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"

            ({ config, lib, ... }: {
              boot.loader.grub.enable = lib.mkForce true;  # <-- crucial fix
              boot.loader.grub.efiSupport = true;
              boot.loader.grub.efiInstallAsRemovable = true;
              boot.loader.grub.device = "nodev";
              boot.loader.grub.useOSProber = true;

              isoImage.makeEfiBootable = true;
              isoImage.makeUsbBootable = true;

              environment.systemPackages = with pkgs; [
                vim git htop wget
              ];

              services.openssh.enable = true;

              users.users.nixos.password = "nixos";
            })
          ];
        };
      in {
        packages.isoImage = nixosSystem.config.system.build.isoImage;
        defaultPackage = self.packages.${system}.isoImage;
      });
}
