# lib/helper.nix
{ inputs, outputs, stateVersion, ... }:
{
  # Added hostModules argument to specify the primary configuration module(s)
  mkNixos = { system, hostname, username, hostModules ? [ ], extraModules ? [ ] }:
    let
      pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
      unstablePkgs = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      # Pass hostname down for the module to use
      specialArgs = { inherit pkgs unstablePkgs inputs system hostname username; };
      modules = [
        # Include common NixOS settings
        ../hosts/common/nixos-common.nix
        # Include VSCode server module if available
        (inputs.vscode-server.nixosModules.default or { })
      ] ++ hostModules # Include the specific host modules passed in
      ++ extraModules; # Include any additional extra modules
    };
}
