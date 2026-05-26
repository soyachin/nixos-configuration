{ config, ... }:
{
  sops.secrets."cf_access_aud" = { owner = "urbania"; };
  sops.templates."urbania-backend-env" = {
    content = ''CF_ACCESS_AUD=${config.sops.placeholder."cf_access_aud"}'';
    owner = "urbania";
  };

  services.urbania = {
    enable = true;
    backend = {
      cfAccessTeam = "sillao";
      corsOrigins = [
        "http://localhost:5173"
        "http://localhost:4173"
        "https://map.vendeconcarlos.pe"
      ];
      environmentFile = config.sops.templates."urbania-backend-env".path;
    };
    scraper.targets = {
      operations    = [ "VENTA" ];
      propertyTypes = [ "DEPARTAMENTO" "CASA" "OFICINA" "TERRENO" ];
      antiquities   = [ "HASTA_50_ANIOS" "MAS_DE_50_ANIOS" ];
      districts     = [ "San Isidro" "Miraflores" "Magdalena" ];
    };
  };

  systemd.services.urbania-backend.after = [ "sops-nix.service" ];
}
