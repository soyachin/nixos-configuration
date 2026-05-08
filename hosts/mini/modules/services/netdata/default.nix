# hosts/mini/modules/services/netdata/default.nix
# Netdata para métricas del sistema y servicios systemd
{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloudUi = true; };
    config = {
      global = {
        "history" = "86400";
        "memory mode" = "dbengine";
        "page cache size" = "64";
        "dbengine multihost disk space" = "512";
      };
      web = {
        "mode" = "static-threaded";
        "bind to" = "127.0.0.1:19999";
        "allow origin" = "https://netdata.nyarkovchain.site";
      };
    };
  };

  systemd.services.netdata.serviceConfig = {
    SupplementaryGroups = [ "systemd-journal" ];
  };
}
