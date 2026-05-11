{ ... }:
{
  imports = [
    ./cli.nix
    ./gui.nix
    ./dev.nix
    ./fonts.nix
    ./media.nix
    ./wayland.nix
    ./steam.nix
    ./custom
  ];
}
