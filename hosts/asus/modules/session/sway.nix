{ pkgs, lib, ... }: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
    extraPackages = with pkgs; [
      adwaita-icon-theme
      gnome-themes-extra
    ];
    extraSessionCommands = ''
      export NIXOS_OZONE_WL=1
    '';
  };

  services.displayManager.sddm.enable = lib.mkForce false;

  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*"; 
  };

  environment.systemPackages = with pkgs; [
    grim
    slurp
    sway-contrib.grimshot
    swaybg
    swaylock
  ];
}
