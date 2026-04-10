{ pkgs, ... }: {
  environment.variables = {
    XCURSOR_THEME = "macOS";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
      };
    };
  };

  systemd.user.services.xdg-desktop-portal-gtk = {
    environment = {
      GTK_THEME = "Gruvbox-Dark";
      ADW_DEBUG_COLOR_SCHEME = "prefer-dark"; 
    };
  };

  systemd.user.services.xdg-desktop-portal-hyprland = {
    environment = {
      GTK_THEME = "Gruvbox-Dark";
    };
  };
}
