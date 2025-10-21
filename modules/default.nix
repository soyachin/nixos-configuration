{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./boot
    ./font
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
