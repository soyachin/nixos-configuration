{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services.displayManager.sessionPackages = [
    pkgs.niri
  ];

  programs.niri.enable = true;
  services.displayManager.sddm.enable = lib.mkForce false; # Desactiva SDDM

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # El comando DEBE estar dentro de default_session
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --width 50 --cmd niri-session";
        user = "greeter";
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.comic-shanns-mono
  ];
  services.upower.enable = true;

  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Ver errores en journalctl -u greetd
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services.swaylock = { };

  programs.dconf.enable = true;

  services.noctalia-shell.enable = true;
}
