{
  inputs,
  urbaniaPkg,
  ...
}:
{
  imports = [
    ./tailscale.nix
    ./media.nix
    ./nginx
    ./glance
    urbaniaPkg.nixosModules.urbania
    ./urbania.nix
    ./vaultwarden.nix
    ./trama.nix
  ];
}
