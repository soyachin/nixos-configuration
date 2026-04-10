{
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
    ./programs
    inputs.home-manager.nixosModules.home-manager
    inputs.noctalia.nixosModules.default
  ];

  networking.hostName = "asus";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  system.stateVersion = "24.11";
}
