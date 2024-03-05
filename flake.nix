{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        
        runtimeLibs = pkgs.lib.makeLibraryPath (with pkgs; ([
            gtk2
            sqlite
            openal
            cairo
            libGLU
            SDL2
            freealut
            libglvnd
            pipewire
            libpulseaudio
          ]
          ++ (with xorg; [
            libX11
            libXi
          ])));
        
      in {
        devShells.default = pkgs.mkShell {
          LD_LIBRARY_PATH = runtimeLibs;
          buildInputs = [
            pkgs.dotnetCorePackages.sdk_7_0
            pkgs.netcoredbg
          ];
        };
      }
    );
}
