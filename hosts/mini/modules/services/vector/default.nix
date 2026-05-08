# hosts/mini/modules/services/vector/default.nix
# Opción C: Vector agente ligero para logs estructurados desde journald
# Lee journal de systemd de los servicios urbania y escribe NDJSON
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.urbania;
in
{
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        urbania_journal = {
          type = "journald";
          include_units = [
            "urbania-backend"
            "urbania-scraper"
            "urbania-pipeline"
            "urbania-deploy"
          ];
        };
      };

      transforms = {
        urbania_parse = {
          type = "remap";
          inputs = [ "urbania_journal" ];
          source = ''
            .timestamp = to_string!(.timestamp)
            .service = del(.SYSLOG_IDENTIFIER) ?? "urbania"
            .message = del(.message)
            .unit = del(._SYSTEMD_UNIT) ?? "unknown"
            .priority = to_int!(del(.PRIORITY))
          '';
        };
      };

      sinks = {
        urbania_ndjson = {
          type = "file";
          inputs = [ "urbania_parse" ];
          path = "${cfg.dataDir}/logs/urbania.json";
          encoding = {
            codec = "json";
          };
        };

        # Opcional: también escribir a stdout para debugging
        # urbania_console = {
        #   type = "console";
        #   inputs = [ "urbania_parse" ];
        #   encoding = { codec = "json"; };
        # };
      };
    };
  };

  # Asegurar que el directorio de logs exista
  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir}/logs 0750 urbania urbania -"
  ];
}
