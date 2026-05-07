{ ... }: {
  imports = [
    ./tailscale.nix
    ./media.nix
    ./nginx
    ./glance
    ./urbania
    ./netdata
    ./vector
  ];
}
