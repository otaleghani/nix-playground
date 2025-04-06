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
      in {
        packages.isoImage = (pkgs.nixos ({
          system = "${system}";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"

            # Use GRUB as bootloader
            ({ config, lib, ... }: {
              boot.loader.grub.enable = true;
              boot.loader.grub.efiSupport = true;
              boot.loader.grub.efiInstallAsRemovable = true;
              boot.loader.grub.device = "nodev"; # Important for ISO
              boot.loader.grub.useOSProber = true;

              # ISO-related settings
              isoImage.makeEfiBootable = true;
              isoImage.makeUsbBootable = true;

              # Extra packages or customizations (optional)
              environment.systemPackages = with pkgs; [
                neovim
                git
                htop
                wget
              ];

              services.openssh.enable = true;

              users.users.nixos.password = "nixos";
            })
          ];
        })).config.system.build.isoImage;

        defaultPackage = self.packages.${system}.isoImage;
      });
}
