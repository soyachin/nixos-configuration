{ pkgs, ... }:
{
  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "" ];
      };
    };
  };

  systemd.user.services.xdg-desktop-portal-gtk = {
    environment = {
      GTK_THEME = "Gruvbox-Dark";
      ADW_DEBUG_COLOR_SCHEME = "prefer-dark"; 
    };
  };

  systemd.user.services.xdg-desktop-portal-gnome = {
    environment = {
      GTK_THEME = "Gruvbox-Dark";
    };
  };
}
