{ inputs, ... }: {
  imports = [
    ./tailscale.nix
    ./media.nix
    ./nginx
    ./glance
    inputs.urbania.nixosModules.urbania
    ./urbania.nix
    ./netdata
    ./vector
  ];
}
