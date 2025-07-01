{ config, pkgs, inputs, unstable, ... }: {

  home.username = "hojas";
  home.homeDirectory = "/home/hojas";
  home.stateVersion = "25.05";
  
  imports = [
   ./modules
   inputs.sops-nix.homeManagerModules.sops
  ];


  home.packages = with pkgs; [
    lolcat cowsay figlet fortune cmatrix hollywood jp2a

    jetbrains.clion

    wine winetricks lutris
    obsidian
    freeoffice
    openutau

    keepassxc
    ardour
    prismlauncher

    sops
    age
    mopidy
    ncmpcpp
    lazygit

    unstable.spotify
    unstable.librewolf
  ];


 }
