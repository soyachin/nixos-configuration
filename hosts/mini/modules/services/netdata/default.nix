# hosts/mini/modules/services/netdata/default.nix
# Opción B: Netdata para métricas del sistema y servicios systemd
# Detecta automáticamente servicios systemd, CPU, RAM, I/O por proceso
{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.netdata = {
    enable = true;
    config = {
      global = {
        "history" = "86400";
        "memory mode" = "dbengine";
        "page cache size" = "64";
        "dbengine multihost disk space" = "512";
      };
      web = {
        "mode" = "static-threaded";
        "web files directory" = "${pkgs.netdata}/share/netdata/web";
        "bind to" = "127.0.0.1:19999";
      };
    };
  };

  # Netdata necesita acceso al journal para métricas de systemd
  systemd.services.netdata.serviceConfig = {
    SupplementaryGroups = [ "systemd-journal" ];
  };
}
