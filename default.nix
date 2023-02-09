{ pkgs, ... }:
pkgs.perlPackages.buildPerlPackage {
  pname = "LINZ-Utils";

  version = "0.0.1";

  src = pkgs.lib.cleanSource ./.;

  propagatedBuildInputs = [
    pkgs.perlPackages.ModuleBuild
    pkgs.perlPackages.TestException
  ];

  preConfigure = ''
    patchShebangs ./configure.bash
    ./configure.bash
  '';
}
