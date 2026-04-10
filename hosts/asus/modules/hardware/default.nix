{ ... }: {
  imports = [
    ./base.nix
    ./asusd.nix
    ./bluetooth.nix
    ./boot
    ./nvidia
    ./printing
  ];
}
