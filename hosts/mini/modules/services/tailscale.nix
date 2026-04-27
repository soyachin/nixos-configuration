{ config, ... }:
{
  # Servicio de VPN (Tailscale)
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-exit-node" ];
    authKeyFile = config.sops.secrets.tailscale_mini_key.path;
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];
}
