{ pkgs, lib, inputs, ... }:
{
  programs.niri.enable = true;

  services.displayManager.sddm.enable = lib.mkForce false;

  services.displayManager.sessionPackages = [ pkgs.niri ];

  programs.dconf.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
