{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    naersk,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        naersk-lib = pkgs.callPackage naersk {};

        simple-http-server = naersk-lib.buildPackage ./.;

        dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "simple-http-server";
          tag = "latest";
          contents = [simple-http-server];
          config = {
            Cmd = ["${simple-http-server}/bin/simple-http-server"];
          };
        };
      in
        with pkgs; {
          packages = {
            inherit simple-http-server dockerImage;
            default = simple-http-server;
          };
          devShell = mkShell {
            buildInputs = [simple-http-server cargo rustc rustfmt rustPackages.clippy dive just];
            RUST_SRC_PATH = rustPlatform.rustLibSrc;
          };
        }
    );
}
