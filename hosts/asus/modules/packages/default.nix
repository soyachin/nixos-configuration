{ ... }: {
  imports = [
    ../../../../modules/packages
    ../../../../modules/packages/nixvim.nix
    ./cli.nix
    ./gui.nix
    ./dev.nix
    ./fonts.nix
    ./media.nix
    ./wayland.nix
    ./steam.nix
    ./wine.nix
    ./yazi.nix
    ./custom
  ];
}
