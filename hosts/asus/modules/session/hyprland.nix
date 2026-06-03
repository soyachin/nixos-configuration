{ pkgs, lib, ... }: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm.enable = lib.mkForce false;
  services.displayManager.sessionPackages = [ pkgs.hyprland ];

  programs.dconf.enable = true;

  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
