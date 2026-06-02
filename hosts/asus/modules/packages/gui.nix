{
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  programs.wireshark.enable = true;

  environment.systemPackages = with pkgs; [
    sirikali
    koodo-reader
    # Gaming
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
    inputs.sharemii.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Office & Productivity
    onlyoffice-desktopeditors
    onlyoffice-documentserver
    obsidian
    xournalpp
    (symlinkJoin {
      name = "protege";
      paths = [ protege ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/protege \
          --set _JAVA_AWT_WM_NONREPARENTING 1
      '';
    })
    # Communication
    discord
    zoom-us

    # Browsers
    ungoogled-chromium
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
    prismlauncher
    # Development Tools
    postman
    opencode
  ];
}
