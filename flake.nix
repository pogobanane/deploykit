{
  description = "Execute commands remotely and locally in parallel for a group of hosts with
python";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      systems = self.inputs.nixpkgs.legacyPackages.x86_64-linux.openssh.meta.platforms;
      perSystem = { self', pkgs, ...}: {
        packages.deploykit = pkgs.python3.pkgs.callPackage ./nix/default.nix {};
        packages.default = self'.packages.deploykit;
        devShells.default = pkgs.callPackage ./nix/shell.nix {};
      };
    };
}
