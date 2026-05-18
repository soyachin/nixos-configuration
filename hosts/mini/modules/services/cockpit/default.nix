# hosts/mini/modules/services/cockpit/default.nix
# Cockpit para observabilidad web de servicios y sistema
# Reemplaza netdata (que requeria compilacion local por withCloudUi)
{ lib, ... }:
{
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        AllowUnencrypted = true; # nginx maneja TLS via Cloudflare
        Origins = lib.mkForce "https://netdata.nyarkovchain.site";
      };
    };
  };
}
