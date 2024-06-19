{ config, lib, pkgs, ... }:

{
  # No imports needed, we are running this in a vm
  # imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Creating a normal user in the wheel group named alice
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    # Sets plaintext unsecured password
    initialPassword = "test";

    # You should use an hashed password instead of a plain text one
    # initialHashedPassword = "";

    # You could even set an openssh key to login
    # openssh.authorizedKeys = [
    #   "ssh.rsa THEKEY example@host"
    # ];
  };

  # Adds packages from pkgs
  environment.systemPackages = with pkgs; [
    cowsay
    lolcat
  ];

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # enable GNOME DE
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # You should use

  system.stateVersion = "23.11"; # Did you read the comment?
}
