{ stdenv, lib }:
let
  fs = lib.fileset;
  # sourceFiles = fs.gitTracked ./.; 
  # This is used to add to the fileset only git tracked files. 
  # This is not needed for flakes because they only track files in a git repo
  sourceFiles = fs.intersection [
    (fs.gitTracked ./.)
    (fs.union [
      ./hello.txt
      ./world.txt
      ./build.sh
    ])
  ];
  # Intersection on the other hand gives you the ability to add items that
  # are both in the first and second argoument
  # In this case we are adding items that are both git tracked and in
  # the fs.union fileset comprised of hello.txt, world.txt and build.sh
in

fs.trace sourceFiles

stdenv.mkDerivation {
  name = "fileset";
  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };
  postInstall = ''
    cp -vr . $out
  ''
}
