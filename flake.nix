{
  description = "api-ts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: (
    flake-utils.lib.eachDefaultSystem (
      system: (
        let
          pkgs = nixpkgs.legacyPackages.${system};
          turbo = pkgs.callPackage ({
            stdenv,
            lib,
            fetchurl,
            openssl,
            zlib,
            autoPatchelfHook,
          }:

          stdenv.mkDerivation rec {
            name = "turbo";
            src = fetchurl {
              url = https://registry.npmjs.org/turbo-linux-64/-/turbo-linux-64-1.10.12.tgz;
              sha256 = "sha256-afrF4/j892ucAtDsM3y23hMdSNl5pwXJHxun1wDk9qQ=";
            };

            nativeBuildInputs = [
              autoPatchelfHook
            ];

            installPhase = ''
              mkdir -p $out/bin
              cp bin/* $out/bin
            '';
          }) {};
        in {
          devShell = pkgs.mkShell {
            name = "api-ts-shell";

            packages = with pkgs; [
              nodejs
              turbo
            ];

            shellHook = ''
              export TURBO_BINARY_PATH=${pkgs.lib.getExe turbo}
              export PATH="$(pwd)/node_modules/.bin:$PATH"
            '';
          };
        }
      )
    )
  );
}
