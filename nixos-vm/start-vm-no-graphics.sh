#!/bin/sh

# This command will run the vm on the current terminal due to -nographic. tty50 will show the boot process on screen
QEMU_KERNEL_PARANS=console=tty50 ./result/bin/run-nixos-vm -nographic; reset
