{ inputs, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  environment.systemPackages = with pkgs; [
    ## stable
    ansible
    drill
    figurine
    git
    htop
    iperf3
    go-task
    just
    python3
    tree
    watch
    wget
    vim
    nix-ld

    # requires nixpkgs.config.allowUnfree = true;
    vscode-extensions.ms-vscode-remote.remote-ssh

    #nixpkgs-unstable.legacyPackages.${pkgs.system}.beszel
  ];
}
