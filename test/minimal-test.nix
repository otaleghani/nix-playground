# nixos gives you a lot of different tools to work with CI/CD
# One of them is testing
# for starters you'll need to import pkgs
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

# Every test has a set of nodes, each having a different name
# it also needs to have a name and a test scripts
# 
pkgs.testers.runNixOSTest {
  name = "minimal-test";

  # Every node has a unique name
  nodes = { 

    # It's basically the configuration of the machine
    machine = { config, pkgs, ... }: {
      # In this case we are creating a user alice that can open firefox
      users.users.alice = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [
          firefox
          tree
        ];
      };

      # We then specify the system version
      system.stateVersion = "23.11";
    };

  };

  # Here, in the testScript, we specify in python what test we want to do
  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("su -- alice -c 'which firefox'")
    machine.fail("su -- root -c 'which firefox'")
  '';
  # "machine" refers to the node that we created before
  # machine.succeed # ok if command in "" succeeds
  # machine.fail # ok if command in "" fails
}

# Remember that every single test is saved in the nix-store. 
# To repeat a test, you'll need to remove it first
# result=$(readlink -f ./result) rm ./result && nix-store --delete $result
