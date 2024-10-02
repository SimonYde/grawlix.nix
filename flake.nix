{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    grawlix = {
      url = "github:jo1gi/grawlix";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      grawlix,
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      packages.x86_64-linux.grawlix = pkgs.callPackage ./. {
        inherit grawlix;
      };
      packages.x86_64-linux.default = self.packages.x86_64-linux.grawlix;
    };
}
