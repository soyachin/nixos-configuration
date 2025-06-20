{ config, pkgs, inputs, unstable, ... }: {

  home.username = "hojas";
  home.homeDirectory = "/home/hojas";
  home.stateVersion = "25.05";
  
  imports = [
   ./modules
   inputs.sops-nix.homeManagerModules.sops
  ];


  home.packages = with pkgs; [
    lolcat cowsay
    figlet fortune cmatrix hollywood jp2a

    jetbrains.clion

    wine winetricks lutris
    obsidian
    freeoffice
    openutau

    clang  # Para soporte C/C++
    nil # Soporte para nix
    alejandra
    pyright
    cmake 

    wl-clipboard
    cmake-language-server
    keepassxc
    ardour
    prismlauncher

    bat
    lsd
    ripgrep
    fd

    sops
    age
    mopidy
    ncmpcpp
    lazygit
    unstable.spotify
  ];


 }
