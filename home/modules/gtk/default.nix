{
  config,
  pkgs,
  ...
}: {
  gtk.enable = true;

  gtk.theme = {
    name = "Gruvbox-Dark";
    package = pkgs.gruvbox-gtk-theme;
  };

  gtk.iconTheme = {
    name = "Gruvbox-Dark";
    package = pkgs.gruvbox-gtk-theme;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "ComicShannsMono Nerd Font Mono 12";
      monospace-font-name = "ComicShannsMono Nerd Font Mono 12";
      document-font-name = "ComicShannsMono Nerd Font Mono 12";
      gtk-theme = "Gruvbox-Dark";
      icon-theme = "Gruvbox-Dark";
      cursor-theme = "macOS";
      cursor-size = 32;
    };
  };
}
