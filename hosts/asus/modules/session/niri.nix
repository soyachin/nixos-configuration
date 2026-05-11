{ pkgs, lib, inputs, ... }:
{
  programs.niri.enable = true;

  services.displayManager.sessionPackages = [
    pkgs.niri
  ];

  services.displayManager.sddm.enable = lib.mkForce false;


  security.pam.services.swaylock = {};

  programs.dconf.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
