let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  package = import ./default.nix {
    inherit pkgs;
  };

  perlEnv = pkgs.perl.withPackages (
    ps: [
      package
    ]
  );
in
pkgs.mkShell {
  buildInputs = [
    pkgs.bashInteractive
    pkgs.cacert
    pkgs.docker
    pkgs.dpkg
    pkgs.fakeroot
    pkgs.gitFull
    pkgs.nodejs
    perlEnv
    pkgs.pre-commit
    pkgs.which
  ];
}
