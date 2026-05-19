{ pkgs, ... }: {
  # Servicio Jellyfin (Media Server)
  # openFirewall REMOVIDO: exponía el puerto 8096 directamente, bypaseando
  # Cloudflare Tunnel y revelando la IP real del servidor.
  # Jellyfin ya es accesible vía nginx → jelly.nyarkovchain.site.
  services.jellyfin = {
    enable = true;
    dataDir = "/var/lib/jellyfin";
  };
}
