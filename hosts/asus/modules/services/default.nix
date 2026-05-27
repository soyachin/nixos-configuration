{ ... }: {
  imports = [
    ./autoskip.nix
  ];

  services.udisks2.enable = true; 
  services.upower.enable = true;
}
