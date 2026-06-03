{ pkgs, ... }: {
  home.username = "hojas";
  home.homeDirectory = "/home/hojas";
  home.stateVersion = "25.05";

  imports = [
    ./modules
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = true;
    withPython3 = true;
  };

  home.packages = with pkgs; [
    git
    ripgrep
    fd
    lazygit
    nodejs
  ];

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}
