{
  description = "PyNoter";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # pynoter.url = "github:maxrousseau/pynoter";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
      {
        devShells = forEachSupportedSystem ({ pkgs }: {
          default = pkgs.mkShell {
            venvDir = ".venv";            
            packages = with pkgs; [ python311 poetry ] ++
                                  (with pkgs.python311Packages; [
                                    pip
                                    venvShellHook
                                    numpy
                                  ]);
          };
          poetry = pkgs.mkShell {
            packages = [ pkgs.poetry ];
          };
        });
      };
}

  # poetry init, lock, add [lib]
