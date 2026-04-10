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
    description = "CloudFlare Tunnel (Declarative)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      DynamicUser = true;
      Restart = "on-failure";
      RestartSec = "5s";
      LoadCredential = [ "token:${config.sops.secrets.cloudflared_token.path}" ];
      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel run --token-file %d/token";

      # Sandboxing
      CapabilityBoundingSet = "";
      DevicePolicy = "closed";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallFilter = [ "@system-service" "~@privileged" ];
      UMask = "0077";
    };
  };
}
