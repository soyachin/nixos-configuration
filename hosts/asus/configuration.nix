{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
    inputs.home-manager.nixosModules.home-manager
    inputs.noctalia.nixosModules.default
  ];

  networking.hostName = "asus"; # Define your hostname.

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
  };

  programs.zsh.enable = true;
  programs.wireshark.enable = true;

  users.users.hojas = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "bluetooth" "wireshark"];
  };

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${system}.default
    # System Utilities
    zsh
    scrcpy
    # Applications
    onlyoffice-desktopeditors
    onlyoffice-documentserver
    equibop
    obsidian
    prismlauncher
    zoom-us
    wine
    winetricks
    wireshark
    quickemu

    # User Applications
    qbittorrent
    xournalpp
    krita
    ungoogled-chromium
    pavucontrol

    # Multimedia
    mpv
    vlc
    rmpc

    # Development
    nil
    alejandra
    tailwindcss-language-server
    svelte-language-server
    cmake
    cmake-language-server
    clang-tools
    gcc
    pyright
    vscode-langservers-extracted
    lua-language-server

    # Wayland Ecosystem
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    swaybg
    swww
    rofi-wayland
    slurp
    mako
    xwayland-satellite
    wl-clipboard
    kitty
    ntfs3g
    # Graphics
    aseprite
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
