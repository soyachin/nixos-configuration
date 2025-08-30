{ config, pkgs, inputs, unstable, ... }: {

  home.username = "hojas";
  home.homeDirectory = "/home/hojas";
  home.stateVersion = "25.05";
  
  imports = [
   ./modules
   inputs.sops-nix.homeManagerModules.sops
  ];


  home.packages = with pkgs; [
    lolcat cowsay figlet fortune cmatrix hollywood jp2a wl-clipboard

    jetbrains.clion
    soulseekqt
    wine winetricks lutris
    obsidian

    onlyoffice-desktopeditors
    onlyoffice-documentserver

    prismlauncher
    zoom-us
    sops
    age
    mopidy
    ncmpcpp
    lazygit

    spotify
    unstable.librewolf
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
 }


