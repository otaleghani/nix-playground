# Working with local files
# fs.difference = removes all files from first argounment that are in the second
# fs.maybeMissing = marks the file as "maybe missing"
# fs.union = creates a new set of files (a union)

# Nix sources everything by default
{ stdenv, lib }:
let
  fs = lib.fileset;
  # sourceFiles = fs.difference ./. (fs.maybeMissing ./result);
  sourceFiles =
  
    fs.difference
      ./. # Here we are sourcing everyghing in the project dir
      (fs.unions [ # And here we are defyning what to exlude
        (fs.maybeMissing ./result)
        # ./default.nix
        # ./build.nix 
        (fs.fileFilter (file: file.hasExt "nix") ./.)
      ]);
in

fs.trace sourceFiles # This is used to show pretty print the trace

stdenv.mkDerivation {
  name = "fileset";
  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };
  postInstall = ''
    mkdir $out
    cp -v {world,hello}.txt $out
  '';
}
