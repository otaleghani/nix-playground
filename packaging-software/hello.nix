# A package is basically a nix expression that evaluates to a derivation
# Every package need a name (pname) and a version
# It next needs to fetch the source code.
# It also needs an hash that cannot be known before the source code is downloaded.
# So the first time you just need to declare it, run the code, and use hash in the error message 

# You need to use the cmd nix-build to make this derivation

{ 
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation {
  pname = "hello";
  version = "2.12.1";
  src = fetchzip {
    url = "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz";
    sha256 = "sha256-1kJjhtlsAkpNB7f6tZEs+dbKd8z7KoNHyDHEJ0tmhnc=";
  };
}
