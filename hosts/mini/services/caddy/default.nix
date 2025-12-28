{ config, pkgs, ... }: {
  services.caddy = {
    enable = true;
    extraConfig = ''
      # Subdominio para Jellyfin
      jellyfin.mini.tu-usuario.ts.net {
          reverse_proxy localhost:8096
      }

      # Subdominio para Audiobookshelf
      audio.mini.tu-usuario.ts.net {
          reverse_proxy localhost:4000
      }
    '';
    # Permitir que Caddy pida certificados SSL a Tailscale
    services.tailscale.permitCertDotNet = true;

    # Dar permiso a Caddy para acceder al socket de Tailscale
    users.users.caddy.extraGroups = [ "tailscale" ];
  };
}
