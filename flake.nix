{
  description = "guile-libyaml flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.05";
    };
  };

  outputs =
    { self
    , nixpkgs
    , ...
    } @ inputs:
    let
      systems = [ "x86_64-linux" ];
    in
    {
      packages = nixpkgs.lib.genAttrs systems (system:
        let
          nixpkgs = inputs.nixpkgs.legacyPackages.${system};
          callPackage = nixpkgs.lib.callPackageWith pkgs;
          pkgs = rec {
            guile-nyacc = callPackage ./nyacc.nix {
              lib = nixpkgs.lib;
              stdenv = nixpkgs.stdenv;
              guile = nixpkgs.pkgs.guile_3_0;
              scheme-bytestructures = nixpkgs.scheme-bytestructures;
              #writeText = nixpkgs.writeText;
              #makeWrapper =makeWrapper;
            };
            guile-libyaml = nixpkgs.callPackage ./libyaml.nix {
              lib = nixpkgs.lib;
              stdenv = nixpkgs.stdenv;
              guile = nixpkgs.pkgs.guile_3_0;
              #
              libyaml = nixpkgs.libyaml;
              guile-nyacc = guile-nyacc;
              #
              scheme-bytestructures = nixpkgs.scheme-bytestructures;
              fetchFromGitHub = nixpkgs.fetchFromGitHub;
            };
          };
        in
        #nixpkgs // pkgs
          ## as nix flake show spits out an error to prevent evaluating nixpkgs 
          ## entirely
        pkgs
      );
      formatter = nixpkgs.lib.genAttrs systems (system:
        nixpkgs.legacyPackages."${system}".nixpkgs-fmt
      );
    };
}
