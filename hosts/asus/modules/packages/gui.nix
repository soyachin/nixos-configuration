{ pkgs, inputs, unstable, ... }:
{
  programs.wireshark.enable = true;

  environment.systemPackages = with pkgs; [
    # Gaming
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin

    # Office & Productivity
    onlyoffice-desktopeditors
    onlyoffice-documentserver
    obsidian
    xournalpp

    # Communication
    discord
    zoom-us

    # Browsers
    librewolf
    ungoogled-chromium
    google-chrome
    antigravity

    # System Utilities
    wireshark
    filezilla
    bottles
    burpsuite
    qbittorrent
    pavucontrol
    gparted
    nautilus
    loupe

    # Themes & Icons (needed by HM GTK config)
    adwaita-icon-theme
    gruvbox-dark-gtk

    # Creative
    bitwig-studio
    krita
    qgis

    # Development Tools
    postman
    opencode

    # From unstable
    unstable.mistral-vibe
  ];
}
