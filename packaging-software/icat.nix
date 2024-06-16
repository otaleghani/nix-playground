{
  stdenv,
  fetchFromGitHub,
  imlib2,
  xorg,
}:
stdenv.mkDerivation {
  pname = "icat";
  version = "v0.5";

  # nix-prefetch-url --unpack https://github.com/atextor/icat/archive/refs/tags/v0.5.tar.gz --type sha256
  # This is a way to get the hash before building the package
  # In the case of github stuff you want to have both --unpack and --type sha256, because if not you will be targetting the tarball

  src = fetchFromGitHub {
    owner = "atextor";
    repo = "icat";
    rev = "v0.5";
    sha256 = "0wyy2ksxp95vnh71ybj1bbmqd5ggp13x3mk37pzr99ljs9awy8ka";
  };
  
  buildInputs = [ imlib2 xorg.libX11 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp icat $out/bin
    runHook postInstall
  '';
}
