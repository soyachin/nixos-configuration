{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./boot
    ./fonts
    ./hardware
    ./locale
    ./network
    ./niri
    ./nix
    ./nvidia
    ./services
    ./steam
    ./tailscale
  ];
}
