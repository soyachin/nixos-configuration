{ config, lib, pkgs, ... }:
let cfg = config.services.caddy;
in {
  networking.firewall.allowedTCPPorts =
    lib.optionals cfg.enable [ 80 443 8084 ];

  sops.templates."Caddyfile" = {
    owner = "caddy";
    content = 
    let 
        domain = "nyarkovchain.site";
        inherit (config.services)
          glance;
    in ''
      {
        acme_dns cloudfare ${
          config.sops.placeholder."caddy/cloudflare_api_token"
        }
      }

      start.${domain}{
        reverse_proxy 127.0.0.1:${toString glance.settings.server.port}
      }

      gello.${domain} {
        reverse_proxy 127.0.0.1:8096
      }

      worm.${domain} {
        reverse_proxy 127.0.0.1:4000
      }
    '';
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-Dvifm7rRwFfgXfcYvXcPDNlMaoxKd5h4mHEK6kJ+T4A=";
    };

    configFile = config.sops.templates."Caddyfile".path;
  };
}
