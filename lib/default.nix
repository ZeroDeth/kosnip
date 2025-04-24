{ inputs, ... }:
let
  helpers = import ./helpers.nix { inherit inputs; };
in
{
  inherit (helpers)
    mkNixos;
  #mkOther;
}
