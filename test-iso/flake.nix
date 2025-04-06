{
  description = "NixOS live ISO with custom configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  
  outputs = { self, nixpkgs }: {
    nixosConfigurations.live = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          # Custom configuration for the live installer ISO
          boot.loader.grub.enable = true;
          boot.loader.grub.device = "nodev";  # Use GRUB without writing to a disk.
          boot.loader.grub.efiSupport = false;  # Disable EFI support (for legacy BIOS systems).
          
          services.openssh.enable = true;     # Enable SSH for remote access.

          # Additional custom settings
          networking.hostName = "nixos-live";
          time.timeZone = "UTC";

          # Include extra packages if needed
          environment.systemPackages = with nixpkgs; [ neovim curl ];
        }
      ];
    };
  };
}
