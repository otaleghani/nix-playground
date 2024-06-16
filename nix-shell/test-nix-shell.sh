nix-shell -p cowsay lolcat --run "cowsay Hello, Nix! | lolcat"
# -p (--packages) [declare your packages]
# -r (--run) [runs ones]
# If you forgot some packages, you can always nest a nix-shell by calling it again
