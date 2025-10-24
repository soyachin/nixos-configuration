{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    # Include the results of the hardware scan.
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

  users.users.hojas = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "bluetooth"];
  };

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${system}.default
    # System Utilities
    unrar
    unzip
    p7zip
    yt-dlp
    wget
    scrcpy
    tmux
    zsh
    git
    tree
    neovim
    libnotify
    bc
    lazygit

    # Applications
    baobab
    nautilus
    papers
    loupe
    gnome-text-editor
    gnome-usage
    onlyoffice-desktopeditors
    onlyoffice-documentserver
    equibop
    obsidian
    prismlauncher
    zoom-us
    sops
    age

    # Terminal Tools
    bat
    lsd
    ripgrep
    fd
    htop
    btop
    lldb
    acpi
    yazi
    nitch

    # User Applications
    qbittorrent
    xournalpp
    krita
    ungoogled-chromium
    pavucontrol
    playerctl

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
