# hosts/mini/modules/services/nginx/default.nix
{
  config,
  pkgs,
  ...
}:
{
  sops.secrets."cloudflared_token" = { };

  services.nginx = {
    enable = true;
    # Nginx corre como grupo urbania para leer archivos del repo
    group = "urbania";
    
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

      "blog.nyarkovchain.site" = {
        root = "/var/www/blog.nyarkovchain.site";
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
      };

      "api.vendeconcarlos.pe" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
          proxyWebsockets = true;

          extraConfig = ''
            # Pasa los headers de Cloudflare Access al backend
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header CF-Access-Jwt-Assertion $http_cf_access_jwt_assertion;
            proxy_set_header CF-Access-Authenticated-User-Email $http_cf_access_authenticated_user_email;

            # Timeouts generosos para queries pesadas de DuckDB
            proxy_read_timeout 60s;
            proxy_send_timeout 60s;
          '';
        };
      };

      "map.vendeconcarlos.pe" = {
        root = "/var/www/map.vendeconcarlos.pe";
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
      };

      "vault.nyarkovchain.site" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
        };
      };

      "netdata.nyarkovchain.site" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9090";
          proxyWebsockets = true;

          extraConfig = ''
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host              $host;

            # Cockpit requiere estos headers para funcionar detras de proxy
            proxy_set_header X-Forwarded-Host  $host;
            proxy_set_header X-Forwarded-Port  443;

            proxy_buffering off;
            gzip off;
          '';
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/www/blog.nyarkovchain.site 0755 deploy deploy -"
    "d /var/www/map.vendeconcarlos.pe 0755 root root -"
  ];

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
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run --token-file %d/token";

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
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
      UMask = "0077";
    };
  };
}
