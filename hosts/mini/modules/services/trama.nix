# hosts/mini/modules/services/trama.nix
{ config, inputs, ... }:
{
  services.trama = {
    enable = true;
    dataDir = "${inputs.trama.packages.x86_64-linux.default}/share/trama";
    domain = null;  # nginx manual en ./nginx/default.nix
    port = 8001;    # 8000 lo usa urbania
    corsOrigins = "https://trama.nyarkovchain.site,http://localhost:5173";
    openFirewall = false;
  };

  # Si quieres docs en desarrollo, cámbialo a true
  services.trama.enableDocs = false;
}
