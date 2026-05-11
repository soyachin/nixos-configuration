{ ... }: {
  imports = [
    ../../../../modules/hardware
    ./base.nix
    ./asusd.nix
    ./bluetooth.nix
    ./nvidia
    ./printing
  ];
}
