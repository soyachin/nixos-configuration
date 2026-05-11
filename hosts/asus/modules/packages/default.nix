{ ... }:
{
  imports = [
    ./cli.nix
    ./gui.nix
    ./dev.nix
    ./fonts.nix
    ./media.nix
    ./wayland.nix
    ./custom
  ];
}
