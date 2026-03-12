{
  description = "Gleam's mascot Lucy recreated in OpenSCAD";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          pkgs,
          ...
        }:
        {
          # Dev shell for 'direnv'
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              # OpenSCAD tooling
              (lib.optionals stdenv.isLinux openscad)
              openscad-lsp

              # Nix tooling
              nil
              nixd
            ];
          };
        };
    };
}
