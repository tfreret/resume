{
  description = "LaTeX CV build environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            texlive.combined.scheme-full
          ];
        };

        packages.default = pkgs.stdenvNoCC.mkDerivation {
          name = "build";
          src = ./.;
          buildInputs = with pkgs; [ texlive.combined.scheme-full ];
          buildPhase = ''
            pdflatex -interaction=nonstopmode cv_en.tex
            pdflatex -interaction=nonstopmode cv_fr.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp cv_en.pdf cv_fr.pdf $out/
          '';
        };
      }
    );
}
