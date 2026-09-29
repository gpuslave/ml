{
  description = "Classic ML dev environment: python + uv (pandas, scikit-learn, torch-cpu, jupyter)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.uv
          pkgs.python3 # interpreter for uv to build the venv on
          pkgs.poppler # pdftoppm — pdf2image backend
          pkgs.tesseract # OCR
          pkgs.qpdf # PDF encryption/manipulation CLI
        ];

        # Let uv-installed wheels (numpy/pandas/torch .so) find libstdc++/libz
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ];
      };
    };
}
