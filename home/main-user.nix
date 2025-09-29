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
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.waybar.enable = true;
}
