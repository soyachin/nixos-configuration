{
  config,
  pkgs,
  inputs,
  unstable,
  ...
}: {
  home.username = "hojas";
  home.homeDirectory = "/home/hojas";
  home.stateVersion = "25.05";

  imports = [
    ./modules
    ../common/theme
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    soulseekqt
    wine
    winetricks
    sops
    age
    spotify
    unstable.librewolf
    gruvbox-gtk-theme
    adwaita-icon-theme
    nerd-fonts.comic-shanns-mono
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    size = 32;
  };

  home.sessionVariables = {
    XCURSOR_SIZE = "32";
    XCURSOR_THEME = "macOS";

    WLR_CURSOR_SIZE = "32";
    WLR_CURSOR_THEME = "macOS";
  };

  # programs.waybar.enable = true;
}
