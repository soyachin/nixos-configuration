{config, pkgs, ...}:

{
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.networkmanager.enable = true;

  networking.firewall.enable = true;

  networking.hostName = "asus"; # Define your hostname.
}