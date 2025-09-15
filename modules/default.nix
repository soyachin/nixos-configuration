{ config, pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./hardware.nix
    ./locale.nix
    ./network.nix
    ./services.nix
    ./steam.nix
  ];
}