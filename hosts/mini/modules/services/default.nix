{ ... }: {
  imports = [
    ./tailscale.nix
    ./media.nix
    ./nginx
    ./glance
  ];
}
