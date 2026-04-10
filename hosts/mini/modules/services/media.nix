{ pkgs, ... }: {
  # Servicio Jellyfin (Media Server)
  services.jellyfin = {
    enable = true;
    dataDir = "/var/lib/jellyfin"; # Usar ruta estándar para evitar problemas de permisos en /home
    openFirewall = true;
  };
}
