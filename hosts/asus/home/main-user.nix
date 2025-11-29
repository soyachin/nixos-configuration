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
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    zsh
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
}
