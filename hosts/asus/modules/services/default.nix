{ ... }: {
  imports = [
    ./autoskip.nix
    ./keyd.nix
  ];

  services.udisks2.enable = true; 
  services.upower.enable = true;
}
