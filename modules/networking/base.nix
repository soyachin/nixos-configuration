{ lib, ... }:
{
  networking.firewall.enable = lib.mkDefault true;

  networking.nameservers = lib.mkDefault [
    "100.100.100.100"
    "1.1.1.1"
  ];

  services.tailscale = {
    enable = lib.mkDefault true;
    extraUpFlags = lib.mkDefault [ "--accept-dns=false" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
