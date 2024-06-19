#!/bin/sh

# this will create an interactive test, so that if something fails you can tinker inside of the vm
$(nix-build -A driverInteractive minimal-test.nix)/bin/nixos-test-driver

# >>> test_script()
# Start testScript attribute
#
# >>> machine.start()
# Starts a specific node (name.start())
#
# >>> start_all()
# Starts all the nodes
#
# >>> machine.shell_interact()
# Enter interactive shell on vm
