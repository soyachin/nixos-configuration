{ ... }: {
  imports = [
    ../../../../modules/networking
    ./networkmanager.nix
    ./firewall.nix
  ];
}
