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

  gtk.cursorTheme = {
    name = "macOS";
    package = pkgs.apple-cursor;
    size = 32;
  };

  gtk.font = {
    name = "ComicShanns Nerd Font Mono Regular";
    package = pkgs.nerd-fonts.comic-shanns-mono;
    size = 13;
  };
}
