{ pkgs, ... }: {
  # Servicio Jellyfin (Media Server)
  services.jellyfin = {
    enable = true;
    dataDir = "/home/aoba/jellyfin/data";
    user = "aoba";
    openFirewall = true;
  };
}
