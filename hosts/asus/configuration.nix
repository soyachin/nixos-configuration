{
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./modules
    ./programs
    inputs.home-manager.nixosModules.home-manager
    inputs.noctalia.nixosModules.default
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  programs.an-anime-game-launcher.enable = true;
  networking.hostName = "asus"; # Define your hostname.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Esenciales para Python y C
    stdenv.cc.cc
    zlib
    openssl
    libffi

    # Para sounddevice (Audio)
    portaudio
    alsa-lib

    # Para tree-sitter y compilación
    gcc

    # Para pyperclip (Portapapeles)
    wl-clipboard # o wl-clipboard si usas Wayland
  ];
  services.asusd.enable = true;

  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

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
    extraGroups = [
      "wheel"
      "networkmanager"
      "bluetooth"
      "wireshark"
      "adbusers"
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ "hojas" ];
      PasswordAuthentication = false;
    };
  };

  environment.variables = {
    XCURSOR_THEME = "macOS";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

  environment.systemPackages = with pkgs; [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
    inputs.noctalia.packages.${system}.default
    unstable.mistral-vibe
    xdg-utils
    glib
    # System Utilities
    scrcpy
    # Applications
    onlyoffice-desktopeditors
    onlyoffice-documentserver
    discord
    obsidian
    zoom-us
    wireshark
    quickemu
    filezilla
    librewolf
    bottles
    ungoogled-chromium
    google-chrome

    # User Applications
    qbittorrent
    xournalpp
    krita
    pavucontrol
    gparted
    nautilus
    loupe
    antigravity

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
    rofi
    rofi-power-menu
    slurp
    mako
    xwayland-satellite
    wl-clipboard
    kitty
    ntfs3g
    apple-cursor
  ];
  nixpkgs.config.allowUnfree = true;

  hardware.enableRedistributableFirmware = true;

  boot.kernelModules = [ "btusb" ];

  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
  };
  system.stateVersion = "24.11"; # Did you read the comment?
}
