{ pkgs, inputs, unstable, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    bitwig-studio
    burpsuite
    # User Applications
    qbittorrent
    xournalpp
    krita
    pavucontrol
    gparted
    nautilus
    loupe
    antigravity
    qgis
    postman

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
    tuigreet
  ];
}
