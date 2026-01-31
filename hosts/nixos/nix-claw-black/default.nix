# nix-claw-black: Sherif's personal AI bot
# Uses standardized bot preset

{ pkgs, ... }:

{
  imports = [
    ./../common/nixos.nix
    ./../common/packages.nix
    ./../common/bot/bot-preset.nix
  ];

  bot = {
    enable = true;
    name = "black";
    owner = "clawzero";
    project = "black-claw";
    environment = "dev_black";
    enablePlugins = [ "sag" ];
  };
}
