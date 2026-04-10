{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  networking.hostName = "mini";

  sops.secrets.tailscale_mini_key = { owner = "root"; };

  system.stateVersion = "25.05";
}
