{
  config,
  pkgs,
  inputs,
  unstable,
  ...
}: let
  volume-up = pkgs.callPackage ./modules/scripts/volume-up.nix {};
  volume-down = pkgs.callPackage ./modules/scripts/volume-down.nix {};
  volume-toggle = pkgs.callPackage ./modules/scripts/volume-toggle.nix {};
  brightness-up = pkgs.callPackage ./modules/scripts/brightness-up.nix {};
  brightness-down = pkgs.callPackage ./modules/scripts/brightness-down.nix {};
  mic-toggle = pkgs.callPackage ./modules/scripts/mic-toggle.nix {};
in {
  home.username = "hojas";
  home.homeDirectory = "/home/hojas";
  home.stateVersion = "25.05";

  imports = [
    ./modules
    inputs.sops-nix.homeManagerModules.sops
    inputs.nyaa.homeManagerModule
  ];

  programs.nyaa.enable = true;

  services.batsignal.enable = true;

  home.packages = with pkgs; [
    lolcat
    cowsay
    figlet
    fortune
    cmatrix
    hollywood
    jp2a
    wl-clipboard

    jetbrains.clion
    soulseekqt
    wine
    winetricks
    lutris
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

    swayidle

    volume-up
    volume-down
    volume-toggle
    brightness-up
    brightness-down
    mic-toggle
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.waybar.enable = true;
}
