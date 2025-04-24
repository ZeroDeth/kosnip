{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { ... }@inputs:
    let
      libx = import ./lib { inherit inputs; };
    in
    {
      nixosConfigurations = {
        nix-llm = libx.mkNixos {
          system = "x86_64-linux";
          hostname = "nix-llm";
          username = "zerodeth";
        };
        nix-komodo-01 = libx.mkNixos {
          system = "x86_64-linux";
          hostname = "nix-komodo-01";
          username = "zerodeth";
        };
        nix-komodo-02 = libx.mkNixos {
          system = "x86_64-linux";
          hostname = "nix-komodo-02";
          username = "zerodeth";
        };
      };
    };
}
