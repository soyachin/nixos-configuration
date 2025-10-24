{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.displayManager.sessionPackages = [
    pkgs.niri
  ];

  programs.niri.enable = true;
  environment.systemPackages = lib.optionals config.services.displayManager.sddm.enable [
    (pkgs.where-is-my-sddm-theme.override {
      variants = ["qt5"];
    })
  ];
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };

  services.upower.enable = true;

  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services.swaylock = {};

  programs.dconf.enable = true;

  services.noctalia-shell.enable = true;
}
