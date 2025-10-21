{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  services.tailscale.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];
}
