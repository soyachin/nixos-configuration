{ ... }: {
  imports = [
    ./packages.nix
    ./nix-ld.nix
    ./wireshark.nix
    ./steam
    ./autoskip.nix
  ];

  programs.anime-game-launcher.enable = true;
}
