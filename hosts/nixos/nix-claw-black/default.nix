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
    imageBackend = "openai";  # openai, gemini, or brave
    
    # Email: Gmail alias for black
    emailAddress = "clawzero.agent+black@gmail.com";
    emailSmtpHost = "smtp.gmail.com";
    emailSmtpUser = "clawzero.agent@gmail.com";
    emailPasswordSecret = "GMAIL_APP_PASSWORD";
  };
}
