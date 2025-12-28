{ config, lib, pkgs, ... }:
{
  sops.secrets."cloudflared_token" = { };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "jelly.nyarkovchain.site" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096"; 
          proxyWebsockets = true;
        };
      };
      "start.nyarkovchain.site" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:5678"; 
          proxyWebsockets = true;
        };
      };
      "books.nyarkovchain.site" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:4000"; 
          proxyWebsockets = true;
        };
      };
    };
  };

  systemd.services.cloudflare-tunnel = {
    description = "Cloudflare Tunnel (SOPS)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
      ExecStart =
        "${pkgs.bash}/bin/bash -c '${pkgs.cloudflared}/bin/cloudflared tunnel run --token $(cat /run/secrets/cloudflared_token)'";
    };
  };
}
